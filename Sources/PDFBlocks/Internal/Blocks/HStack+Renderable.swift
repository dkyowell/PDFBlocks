/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension HStack: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        if keypath == \.computePageCount {
            let blocks = content.getRenderables(environment: environment)
            let result = blocks.reduce(false) { $0 || $1.computePageCount(context: context, environment: environment) }
            return Trait(computePageCount: result)[keyPath: keypath]
        } else {
            return Trait()[keyPath: keypath]
        }
    }

    // NOTE: The layout cache is not only for performance improvements, but also for layout consitency. Without
    // the cache, the layout heuristic in layoutBlocks can return different results when it is called again
    // with its own output as its input. (i.e., given a proposal width of 648, the sizes it returns indicate
    // a width of 636.3; if layoutBlocks is called again with a proposal of 636.3, it might return a different
    // array of sizes.)
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
        environment.layoutAxis = .horizontal
        let blocks = content.getRenderables(environment: environment)
        let proportionalWidths = blocks.map { $0.proportionalWidth(context: context, environment: environment) }
        if proportionalWidths.filter({ $0 != nil }).isEmpty {
            let sizes = layoutBlocks(blocks, context: context, environment: environment, proposal: proposal)
            context.layoutCache[cacheId] = sizes
            let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
            let minWidthSum = sizes.map(\.min.width).reduce(0, +) + fixedSpacing
            var maxWidthSum = sizes.map(\.max.width).reduce(0, +) + fixedSpacing
            if spacing.isFlexible, maxWidthSum < proposal.width {
                maxWidthSum = proposal.width
            }
            let minHeightMax = sizes.map(\.min.height).reduce(0, max)
            let maxHeightMax = sizes.map(\.max.height).reduce(0, max)
            return BlockSize(min: CGSize(width: minWidthSum, height: minHeightMax),
                             max: CGSize(width: maxWidthSum, height: maxHeightMax))
        } else {
            let sizes = layoutProportionalBlocks(blocks, proportionalWidths: proportionalWidths,
                                                 context: context, environment: environment, proposal: proposal)
            context.layoutCache[cacheId] = sizes
            let maxHeightMax = sizes.map(\.max.height).reduce(0, max)
            let minHeightMax = sizes.map(\.min.height).reduce(0, max)
            return .init(min: CGSize(width: proposal.width, height: minHeightMax),
                         max: CGSize(width: proposal.width, height: maxHeightMax))
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.layoutAxis = .horizontal
        let blocks = content.getRenderables(environment: environment)
        let proportionalWidths = blocks.map { $0.proportionalWidth(context: context, environment: environment) }
        if proportionalWidths.filter({ $0 != nil }).count > 0 {
            let sizes = (context.layoutCache[cacheId] as! [BlockSize]).map(\.max)
            let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
            let adjustedWidth = rect.width - fixedSpacing
            let sumProportionalWidth = proportionalWidths.map { $0 ?? 1 }.reduce(0, +)
            var dx: CGFloat = 0
            for (offset, block) in blocks.enumerated() {
                let proportionalWidth = proportionalWidths[offset] ?? 1
                let proposedWidth = adjustedWidth * (proportionalWidth / sumProportionalWidth)
                let height = sizes[offset].height
                let dy: CGFloat = switch alignment {
                case .top:
                    0
                case .center:
                    (rect.height - height) / 2
                case .bottom:
                    rect.height - height
                }
                let renderRect = CGRect(x: rect.minX + dx, y: rect.minY + dy, width: proposedWidth, height: height)
                block.render(context: context, environment: environment, rect: renderRect)
                dx += proposedWidth + spacing.fixedPoints
            }
        } else {
            let sizes = (context.layoutCache[cacheId] as! [BlockSize]).map(\.max)
            let space: CGFloat
            switch spacing {
            case let .flex(size):
                let sumWidth = sizes.map(\.width).reduce(0, +)
                space = max(size.points, (rect.width - sumWidth) / CGFloat(blocks.count - 1))
            case let .fixed(size):
                space = size.points
            }
            var dx = 0.0
            for (block, size) in zip(blocks, sizes) {
                let dy: CGFloat = switch alignment {
                case .top:
                    0
                case .center:
                    (rect.height - size.height) / 2
                case .bottom:
                    rect.height - size.height
                }
                let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size)
                block.render(context: context, environment: environment, rect: renderRect)
                dx += size.width + space
            }
        }
        return nil
    }
}

extension HStack {
    func layoutBlocks(_ blocks: [any Renderable], context: Context, environment: EnvironmentValues, proposal: Proposal) -> [BlockSize] {
        let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
        let adjustedWidth = proposal.width - fixedSpacing
        let adjustedProposal = CGSize(width: adjustedWidth, height: proposal.height)
        // Size all blocks using the adjustedWidth of the proposal
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: adjustedProposal) }
        var unsizedDict = sizes.enumerated().reduce(into: [:]) { $0[$1.offset] = $1.element }
        var sizedDict = [Int: BlockSize]()
        // Sorted by width, size the non-flexible blocks using the average remaining width
        for (key, _) in unsizedDict.filter({ $0.value.hFlexible == false }).sorted(by: { $0.value.max.width < $1.value.max.width }) {
            let sumSizedWidth = sizedDict.map(\.value.max.width).reduce(0, +)
            let averageWidth = max(0, (adjustedWidth - sumSizedWidth) / CGFloat(unsizedDict.count))
            let averageSize = CGSize(width: averageWidth, height: proposal.height)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposal: averageSize)
            unsizedDict[key] = nil
        }
        // Sorted by width, layout the remaining blocks using the average remaining width
        for (key, _) in unsizedDict.sorted(by: { $0.value.max.width < $1.value.max.width }) {
            let sumSizedWidth = sizedDict.map(\.value.max.width).reduce(0, +)
            let averageWidth = max(0, (adjustedWidth - sumSizedWidth) / CGFloat(unsizedDict.count))
            let averageSize = CGSize(width: averageWidth, height: proposal.height)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposal: averageSize)
            unsizedDict[key] = nil
        }
        return blocks.indices.map { BlockSize(sizedDict[$0]!.max) }
    }

    func layoutProportionalBlocks(_ blocks: [any Renderable], proportionalWidths: [Double?], context: Context, environment: EnvironmentValues, proposal: Proposal) -> ([BlockSize]) {
        let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
        let adjustedWidth = proposal.width - fixedSpacing
        let sumProportionalWidth = proportionalWidths.map { $0 ?? 1 }.reduce(0, +)
        let sizes = blocks.enumerated().map { offset, item in
            let proportionalWidth = proportionalWidths[offset] ?? 1
            let width = adjustedWidth * (proportionalWidth / sumProportionalWidth)
            let blockSize = CGSize(width: width, height: proposal.height)
            return item.sizeFor(context: context, environment: environment, proposal: blockSize)
        }
        return sizes
    }
}
