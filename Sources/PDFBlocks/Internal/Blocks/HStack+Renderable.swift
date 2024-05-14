/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension HStack: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
        environment.layoutAxis = .horizontal
        let blocks = content.getRenderables(environment: environment)
        if blocks.filter({ $0.proportionalWidth(context: context, environment: environment) != nil }).isEmpty == false {
            // PROPORTIONAL LAYOUT
            let blocks = content.getRenderables(environment: environment)
            let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
            let adjustedWidth = proposal.width - fixedSpacing
            let sumProportionalWidth = blocks.map { $0.proportionalWidth(context: context, environment: environment) ?? 1 }.reduce(0, +)
            let sizes = blocks.map { item in
                let width = ((item.proportionalWidth(context: context, environment: environment) ?? 1) / sumProportionalWidth) * adjustedWidth
                let blockSize = CGSize(width: width, height: proposal.height)
                return item.sizeFor(context: context, environment: environment, proposal: blockSize)
            }
            let maxHeight = sizes.map(\.max.height).reduce(0, max)
            let minHeight = sizes.map(\.min.height).reduce(0, max)
            return .init(min: CGSize(width: proposal.width, height: minHeight),
                         max: CGSize(width: proposal.width, height: maxHeight))
        } else {
            // STANDARD LAYOUT
            let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: proposal) }
            let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
            let minHeight = sizes.map(\.min.height).reduce(0, max)
            let minWidth = sizes.map(\.min.width).reduce(0, +) + fixedSpacing
            if minWidth >= proposal.width {
                let maxHeight = sizes.map(\.max.height).reduce(0, max)
                return BlockSize(min: CGSize(width: minWidth, height: minHeight),
                                 max: CGSize(width: minWidth, height: maxHeight))
            } else if spacing.isFlexible, blocks.count > 1 {
                let maxHeight = sizes.map((\.max.height)).reduce(0, max)
                return BlockSize(min: CGSize(width: minWidth, height: minHeight),
                                 max: CGSize(width: proposal.width, height: maxHeight))
            } else {
                let sizes = layoutBlocks(blocks, context: context, environment: environment, proposal: proposal)
                let maxHeight = sizes.map(\.height).reduce(0.0, max)
                let maxWidth = sizes.map(\.width).reduce(0, +) + fixedSpacing
                return BlockSize(min: CGSize(width: minWidth, height: minHeight),
                                 max: CGSize(width: maxWidth, height: maxHeight))
            }
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.layoutAxis = .horizontal
        let blocks = content.getRenderables(environment: environment)
        if blocks.filter({ $0.proportionalWidth(context: context, environment: environment) != nil }).isEmpty == false {
            let blocks = content.getRenderables(environment: environment)
            let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
            let adjustedWidth = rect.width - fixedSpacing
            let sumProportionalWidth = blocks.map { $0.proportionalWidth(context: context, environment: environment) ?? 1 }.reduce(0, +)
            var dx: CGFloat = 0
            for block in blocks {
                let width = ((block.proportionalWidth(context: context, environment: environment) ?? 1) / sumProportionalWidth) * adjustedWidth
                let proposedSize = CGSize(width: width, height: rect.height)
                let height = block.sizeFor(context: context, environment: environment, proposal: proposedSize)
                    .max.height
                let dy: CGFloat = switch alignment {
                case .top:
                    0
                case .center:
                    (rect.height - height) / 2
                case .bottom:
                    rect.height - height
                }
                let renderRect = CGRect(x: rect.minX + dx, y: rect.minY + dy, width: width, height: height)
                block.render(context: context, environment: environment, rect: renderRect)
                dx += width + spacing.fixedPoints
            }
        } else {
            let sizes = layoutBlocks(blocks, context: context, environment: environment, proposal: rect.size)
            //  Compute spacing
            let space: CGFloat
            switch spacing {
            case let .flex(size):
                let sumWidth = sizes.map(\.width).reduce(0, +)
                space = max(size.points, (rect.width - sumWidth) / CGFloat(blocks.count - 1))
            case let .fixed(size):
                space = size.points
            }
            //  Render blocks
            var stackOffset = 0.0
            for (block, size) in zip(blocks, sizes) {
                // Compute alignment
                let dy: CGFloat = switch alignment {
                case .top:
                    0
                case .center:
                    (rect.height - size.height) / 2
                case .bottom:
                    rect.height - size.height
                }
                let renderRect = CGRect(origin: rect.origin.offset(dx: stackOffset, dy: dy), size: size)
                block.render(context: context, environment: environment, rect: renderRect)
                stackOffset += size.width + space
            }
        }
        return nil
    }
}

extension HStack {
    func layoutBlocks(_ blocks: [any Renderable], context: Context, environment: EnvironmentValues, proposal: Proposal) -> ([CGSize]) {
        let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
        let layoutSize = CGSize(width: proposal.width - fixedSpacing, height: proposal.height)
        // Size all blocks with the full width of the proposal less the fixed spacing.
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: layoutSize) }
        var unsizedDict = sizes.enumerated().reduce(into: [:]) { $0[$1.offset] = $1.element }
        var sizedDict = [Int: BlockSize]()
        // Find all blocks that are narrower than the average remaining width.
        var layoutComplete = false
        while layoutComplete == false {
            layoutComplete = true
            let sumSizedWidth = sizedDict.map(\.value.max.width).reduce(0, +)
            let averageWidth = (proposal.width - fixedSpacing - sumSizedWidth) / CGFloat(unsizedDict.count)
            for (key, size) in unsizedDict.sorted(by: { $0.key < $1.key }) {
                if size.max.width <= averageWidth {
                    sizedDict[key] = size
                    unsizedDict[key] = nil
                    layoutComplete = false
                }
            }
        }
        // Size the remaining non-flexible blocks, proposing the average remaining width.
        for (key, _) in unsizedDict.filter({ $0.value.vFlexible == false }).sorted(by: { $0.key < $1.key }) {
            let sumSizedWidth = sizedDict.map(\.value.max.width).reduce(0, +)
            let averageWidth = (proposal.width - fixedSpacing - sumSizedWidth) / CGFloat(unsizedDict.count)
            let averageSize = CGSize(width: averageWidth, height: proposal.height)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposal: averageSize)
            unsizedDict[key] = nil
        }
        // Size the remaining flexible blocks, proposing the average remaining width.
        for (key, _) in unsizedDict.sorted(by: { $0.key < $1.key }) {
            let sumSizedWidth = sizedDict.map(\.value.max.width).reduce(0, +)
            let averageWidth = (proposal.width - fixedSpacing - sumSizedWidth) / CGFloat(unsizedDict.count)
            let averageSize = CGSize(width: averageWidth, height: proposal.height)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposal: averageSize)
            unsizedDict[key] = nil
        }
        return blocks.indices.map { sizedDict[$0]!.max }
    }
}
