/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension VStack: Renderable {
    func layoutBlocks(_ blocks: [any Renderable], context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> ([CGSize]) {
        let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
        let layoutSize = CGSize(width: proposedSize.width, height: proposedSize.height - fixedSpacing)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposedSize: layoutSize) }
        var unsizedDict = sizes.enumerated().reduce(into: [:]) { $0[$1.offset] = $1.element }
        var sizedDict = [Int: BlockSize]()
        // Iterate to find blocks narrower than the average width, changing the average as it goes.
        var layoutComplete = false
        while layoutComplete == false {
            layoutComplete = true
            let sumSizedHeight = sizedDict.map(\.value.max.height).reduce(0, +)
            let averageHeight = (proposedSize.height - fixedSpacing - sumSizedHeight) / CGFloat(unsizedDict.count)
            for (key, size) in unsizedDict.sorted(by: { $0.key < $1.key }) {
                if size.max.height <= averageHeight {
                    sizedDict[key] = size
                    unsizedDict[key] = nil
                    layoutComplete = false
                }
            }
        }
        // Size the remaining non flexibile blocks.
        for (key, _) in unsizedDict.filter({ $0.value.hFlexible == false }).sorted(by: { $0.key < $1.key }) {
            let sumSizedHeight = sizedDict.map(\.value.max.height).reduce(0, +)
            let averageHeight = (proposedSize.height - fixedSpacing - sumSizedHeight) / CGFloat(unsizedDict.count)
            let averageSize = CGSize(width: proposedSize.width, height: averageHeight)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposedSize: averageSize)
            unsizedDict[key] = nil
        }
        // Size the remaining blocks.
        for (key, _) in unsizedDict.sorted(by: { $0.key < $1.key }) {
            let sumSizedHeight = sizedDict.map(\.value.max.height).reduce(0, +)
            let averageHeight = (proposedSize.height - fixedSpacing - sumSizedHeight) / CGFloat(unsizedDict.count)
            let averageSize = CGSize(width: proposedSize.width, height: averageHeight)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposedSize: averageSize)
            unsizedDict[key] = nil
        }
        //  Return results. I don't like to use !, but here if it crashes, it should crash.
        return blocks.indices.map { sizedDict[$0]!.max }
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        var environment = environment
        environment.layoutAxis = .vertical
        if allowPageWrap {
            if environment.renderMode == .wrapping {
                return BlockSize(width: proposedSize.width, height: 0)
            } else {
                return BlockSize(proposedSize)
            }
        } else {
            let blocks = content.getRenderables(environment: environment)
            let sizes = layoutBlocks(blocks, context: context, environment: environment, proposedSize: proposedSize)
            let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
            let maxWidth = sizes.map(\.width).reduce(0.0, max)
            let sumMaxHeight = sizes.map(\.height).reduce(0, +)
            let sumMinHeight = sizes.map(\.height).reduce(0.0, +)
            if case .flex = spacing {
                return .init(min: .init(width: maxWidth, height: min(sumMinHeight + fixedSpacing, proposedSize.height)),
                             max: .init(width: maxWidth, height: proposedSize.height))
            } else {
                return .init(min: .init(width: maxWidth, height: min(sumMinHeight + fixedSpacing, proposedSize.height)),
                             max: .init(width: maxWidth, height: min(sumMaxHeight + fixedSpacing, proposedSize.height)))
            }
        }
    }

    func renderForPageWrap(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let blocks = content.getRenderables(environment: environment)
        blocks.enumerated().forEach { (offset, block) in
            if offset > 0 {
                context.advanceMultipageCursor(spacing.fixedPoints)
            }
            let size = block.sizeFor(context: context, environment: environment, proposedSize: rect.size).max
            let dx: CGFloat
            switch alignment {
            case .leading:
                dx = 0
            case .center:
                dx = (rect.width - size.width) / 2
            case .trailing:
                dx = rect.width - size.width
            }
            let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: 0), size: size)
            context.renderMultipageContent(rect: renderRect, height: size.height) { rect in
                block.render(context: context, environment: environment, rect: rect)
            }
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.layoutAxis = .vertical
        if allowPageWrap {
            if environment.renderMode == .wrapping {
                renderForPageWrap(context: context, environment: environment, rect: rect)
            } else {
                environment.renderMode = .wrapping
                context.beginMultipageRendering(environment: environment, rect: rect)
                context.renderPass2 = {
                    renderForPageWrap(context: context, environment: environment, rect: rect)
                }
            }
        } else {
            //  Get blocks and sizes
            let blocks = content.getRenderables(environment: environment)
            let sizes = layoutBlocks(blocks, context: context, environment: environment, proposedSize: rect.size)
            //  Compute spacing
            let space: CGFloat
            switch spacing {
            case let .flex(size):
                let sumHeight = sizes.map(\.height).reduce(0, +)
                space = max(size.points, (rect.height - sumHeight) / CGFloat(blocks.count - 1))
            case let .fixed(size):
                space = size.points
            }
            //  Render blocks
            var stackOffset = 0.0
            for (block, size) in zip(blocks, sizes) {
                // Compute alignment
                let dx: CGFloat = switch alignment {
                case .leading:
                    0
                case .center:
                    (rect.width - size.width) / 2
                case .trailing:
                    rect.width - size.width
                }
                let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: stackOffset), size: size)
                block.render(context: context, environment: environment, rect: renderRect)
                stackOffset += size.height + space
            }
        }
    }
}
