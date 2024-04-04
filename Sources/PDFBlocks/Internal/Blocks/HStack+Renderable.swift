/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension HStack: Renderable {
    func layoutBlocks(_ blocks: [Renderable], context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> ([CGSize]) {
        let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
        let layoutSize = CGSize(width: proposedSize.width - fixedSpacing, height: proposedSize.height)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposedSize: layoutSize) }
        var unsizedDict = sizes.enumerated().reduce(into: [:]) { $0[$1.offset] = $1.element }
        var sizedDict = [Int: BlockSize]()
        // Iterate to find blocks narrower than the average width, changing the average as it goes.
        var layoutComplete = false
        while layoutComplete == false {
            layoutComplete = true
            let sumSizedWidth = sizedDict.map(\.value.max.width).reduce(0, +)
            let averageWidth = (proposedSize.width - fixedSpacing - sumSizedWidth) / CGFloat(unsizedDict.count)
            for (key, size) in unsizedDict.sorted(by: { $0.key < $1.key }) {
                if size.max.width <= averageWidth {
                    sizedDict[key] = size
                    unsizedDict[key] = nil
                    layoutComplete = false
                }
            }
        }
        // Size the remaining non-flexible blocks.
        for (key, _) in unsizedDict.filter({ $0.value.vFlexible == false }).sorted(by: { $0.key < $1.key }) {
            let sumSizedWidth = sizedDict.map(\.value.max.width).reduce(0, +)
            let averageWidth = (proposedSize.width - fixedSpacing - sumSizedWidth) / CGFloat(unsizedDict.count)
            let averageSize = CGSize(width: averageWidth, height: proposedSize.height)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposedSize: averageSize)
            unsizedDict[key] = nil
        }
        // Size the remaining flexible blocks.
        for (key, _) in unsizedDict.sorted(by: { $0.key < $1.key }) {
            let sumSizedWidth = sizedDict.map(\.value.max.width).reduce(0, +)
            let averageWidth = (proposedSize.width - fixedSpacing - sumSizedWidth) / CGFloat(unsizedDict.count)
            let averageSize = CGSize(width: averageWidth, height: proposedSize.height)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposedSize: averageSize)
            unsizedDict[key] = nil
        }
        //  Return results. I don't like to use !, but here if it crashes, it should crash.
        return blocks.indices.map { sizedDict[$0]!.max }
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        var environment = environment
        environment.allowMultipageBlocks = .false("HStack")
        environment.layoutAxis = .horizontal
        let blocks = content.getRenderables(environment: environment)
        let sizes = layoutBlocks(blocks, context: context, environment: environment, proposedSize: proposedSize)
        let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
        let maxHeight = sizes.map(\.height).reduce(0.0, max)
        let sumMaxWidth = sizes.map(\.width).reduce(0, +)
        //  TODO: I am not sure I am reasoning about th minWidth correctly. I think that I need some
        //  TODO: flexible subviews to experiment more.
        let sumMinWidth = sizes.map(\.width).reduce(0.0, +)
        switch spacing {
        case .flex:
            return .init(min: .init(width: min(sumMinWidth + fixedSpacing, proposedSize.width), height: maxHeight),
                         max: .init(width: proposedSize.width, height: maxHeight))
        case .fixed:
            return .init(min: .init(width: min(sumMinWidth + fixedSpacing, proposedSize.width), height: maxHeight),
                         max: .init(width: min(sumMaxWidth + fixedSpacing, proposedSize.width), height: maxHeight))
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.allowMultipageBlocks = .false("HStack")
        environment.layoutAxis = .horizontal
        //  Get blocks and sizes
        let blocks = content.getRenderables(environment: environment)
        let sizes = layoutBlocks(blocks, context: context, environment: environment, proposedSize: rect.size)
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
}
