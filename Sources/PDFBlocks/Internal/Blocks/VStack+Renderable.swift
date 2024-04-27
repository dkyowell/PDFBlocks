/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension VStack: Renderable {
    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(allowWrap: allowWrap)[keyPath: keypath]
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
        environment.layoutAxis = .vertical
        switch wrapMode(context: context, environment: environment) {
        case .none:
            let blocks = content.getRenderables(environment: environment)
            let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: proposal) }
            let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
            let minWidth = sizes.map(\.min.width).reduce(0, max)
            let minHeight = sizes.map(\.min.height).reduce(0, +) + fixedSpacing
            if minHeight >= proposal.height {
                // TODO: How to reason about minWidth?
                let maxWidth = sizes.map(\.max.width).reduce(0, max)
                return BlockSize(min: CGSize(width: minWidth, height: minHeight),
                                 max: CGSize(width: maxWidth, height: minHeight))
            } else if spacing.isFlexible, blocks.count > 1 {
                let maxWidth = sizes.map(\.max.width).reduce(0, max)
                return BlockSize(min: CGSize(width: minWidth, height: minHeight),
                                 max: CGSize(width: maxWidth, height: proposal.height))
            } else {
                let sizes = layoutBlocks(blocks, context: context, environment: environment, proposal: proposal)
                let maxWidth = sizes.map(\.width).reduce(0.0, max)
                let maxHeight = sizes.map(\.height).reduce(0, +) + fixedSpacing
                return BlockSize(min: CGSize(width: minWidth, height: minHeight),
                                 max: CGSize(width: maxWidth, height: maxHeight))
            }
        case .primary:
            return BlockSize(min: CGSize(width: proposal.width, height: 0), max: proposal)
        case .secondary:
            let blocks = ArraySlice<any Renderable>(content.getRenderables(environment: environment))
            var height = 0.0
            var maxWidth = 0.0
            for (offset, block) in blocks.enumerated() {
                let size = block.sizeFor(context: context, environment: environment, proposal: proposal)
                let spacing = offset == 0 ? 0 : spacing.fixedPoints
                if (height + size.min.height + spacing) ~> proposal.height {
                    break
                } else {
                    height += size.max.height + spacing
                    maxWidth = max(maxWidth, size.max.width)
                }
            }
            return BlockSize(CGSize(width: maxWidth, height: min(height, proposal.height)))
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        switch wrapMode(context: context, environment: environment) {
        case .none:
            renderAtomic(context: context, environment: environment, rect: rect)
            return nil
        case .primary:
            context.renderer.setLayer(2)
            context.setPageWrapRect(rect)
            if context.multiPagePass == nil {
                context.multiPagePass = {
                    renderPrimaryWrap(context: context, environment: environment, rect: rect)
                }
            }
            return nil
        case .secondary:
            return renderSecondaryWrap(context: context, environment: environment, rect: rect)
        }
    }
}

extension VStack {
    func renderAtomic(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.layoutAxis = .vertical
        let size = sizeFor(context: context, environment: environment, proposal: rect.size).max
        let blocks = content.getRenderables(environment: environment)
        let sizes = layoutBlocks(blocks, context: context, environment: environment, proposal: size)
        //  Compute spacing
        let space: CGFloat
        switch spacing {
        case let .flex(size):
            let sumHeight = sizes.map(\.height).reduce(0, +)
            space = max(size.points, (rect.height - sumHeight) / CGFloat(blocks.count - 1))
        case let .fixed(size):
            space = size.points
        }
        var dy = (rect.height - size.height) / 2
        for (block, size) in zip(blocks, sizes) {
            let dx: CGFloat = switch alignment {
            case .leading:
                0
            case .center:
                (rect.width - size.width) / 2
            case .trailing:
                rect.width - size.width
            }
            let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size)
            block.render(context: context, environment: environment, rect: renderRect)
            dy += size.height + space
        }
    }

    func renderPrimaryWrap(context: Context, environment: EnvironmentValues, rect: CGRect) {
        // print("VStack.render.primary", rect)
        var environment = environment
        environment.layoutAxis = .vertical
        environment.renderMode = .wrapping
        var blocks = content.getRenderables(environment: environment)
        var dy: CGFloat = 0
        while blocks.count > 0 {
            let block = blocks[0]
            let remainingSize = CGSize(width: rect.width, height: rect.height - dy)
            let size = block.sizeFor(context: context, environment: environment, proposal: remainingSize)
            let dx: CGFloat = switch alignment {
            case .leading:
                0
            case .center:
                (rect.width - size.max.width) / 2
            case .trailing:
                rect.width - size.max.width
            }
            if dy == 0 || (size.min.height + dy ~<= rect.height) {
                let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size.max)
                let remainder = block.render(context: context, environment: environment, rect: renderRect)
                dy += size.max.height + spacing.fixedPoints
                if let remainder {
                    blocks[0] = remainder
                    if size.min.height + dy > rect.height {
                        dy = 0
                        context.endPage()
                        context.beginPage()
                    }
                } else {
                    blocks = blocks.dropFirst().map { $0 }
                }
            } else {
                dy = 0
                context.endPage()
                context.beginPage()
            }
        }
    }

    func renderSecondaryWrap(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.layoutAxis = .vertical
        var blocks = content.getRenderables(environment: environment)
        // print("VStack.renderSecondaryWrap", blocks.count, rect)
        var dy: CGFloat = 0
        for (offset, block) in blocks.enumerated() {
            let proposal = CGSize(width: rect.size.width, height: rect.size.height - dy)
            let size = block.sizeFor(context: context, environment: environment, proposal: proposal)
            // print("block ", offset, size.min.height, proposal.height, size.max.height)
            // Can this block fit?
            if size.min.height ~<= proposal.height {
                let dx: CGFloat = switch alignment {
                case .leading:
                    0
                case .center:
                    (rect.width - size.max.width) / 2
                case .trailing:
                    rect.width - size.max.width
                }

                let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size.max)
                let remainder = block.render(context: context, environment: environment, rect: renderRect)
                if let remainder {
                    blocks[0] = remainder
                    // print("VStack.returning remainder1", blocks.count)
                    return VStack<ArrayBlock>(alignment: alignment, spacing: spacing, allowWrap: allowWrap, content: { ArrayBlock(blocks: blocks) })
                } else {
                    dy += size.max.height + spacing.fixedPoints
                }
            } else {
                // print("VStack.returning remainder2", blocks.count)
                return VStack<ArrayBlock>(alignment: alignment, spacing: spacing, allowWrap: allowWrap, content: { ArrayBlock(blocks: blocks) })
            }
            blocks = blocks.dropFirst().map { $0 }
            // Catches condition when size can be 0
//            if dy + spacing.fixedPoints >= rect.height, blocks.count > 0 {
//                print("VStack.returning remainder 3")
//                return VStack<ArrayBlock>(alignment: alignment, spacing: spacing, allowWrap: allowWrap, content: { ArrayBlock(blocks: blocks) })
//            }
        }
        // print("VStack.returning nil")
        return nil
    }

    func layoutBlocks(_ blocks: [any Renderable], context: Context, environment: EnvironmentValues, proposal: Proposal) -> ([CGSize]) {
        let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
        let layoutSize = CGSize(width: proposal.width, height: proposal.height - fixedSpacing)

        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: layoutSize) }
        var unsizedDict = sizes.enumerated().reduce(into: [:]) { $0[$1.offset] = $1.element }
        var sizedDict = [Int: BlockSize]()
        // Iterate to find blocks less than the average height, changing the average as it goes.
        var stepComplete = false
        while stepComplete == false {
            stepComplete = true
            let sumSizedHeight = sizedDict.map(\.value.max.height).reduce(0, +)
            let averageHeight = (layoutSize.height - sumSizedHeight) / CGFloat(unsizedDict.count)
            for (key, size) in unsizedDict.sorted(by: { $0.key < $1.key }) {
                if size.max.height <= averageHeight {
                    sizedDict[key] = size
                    unsizedDict[key] = nil
                    stepComplete = false
                }
            }
        }
        // Size the remaining non flexibile blocks.
        for (key, _) in unsizedDict.filter({ $0.value.hFlexible == false }).sorted(by: { $0.key < $1.key }) {
            let sumSizedHeight = sizedDict.map(\.value.max.height).reduce(0, +)
            let averageHeight = (proposal.height - fixedSpacing - sumSizedHeight) / CGFloat(unsizedDict.count)
            let averageSize = CGSize(width: proposal.width, height: averageHeight)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposal: averageSize)
            unsizedDict[key] = nil
        }
        // Size the remaining blocks.
        for (key, _) in unsizedDict.sorted(by: { $0.key < $1.key }) {
            let sumSizedHeight = sizedDict.map(\.value.max.height).reduce(0, +)
            let averageHeight = (proposal.height - fixedSpacing - sumSizedHeight) / CGFloat(unsizedDict.count)
            let averageSize = CGSize(width: proposal.width, height: averageHeight)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposal: averageSize)
            unsizedDict[key] = nil
        }
        //  Return results. I don't like to use !, but here if it crashes, it should crash.
        return blocks.indices.map { sizedDict[$0]!.max }
    }

    func wrapMode(context _: Context, environment: EnvironmentValues) -> WrapMode {
        if allowWrap {
            if environment.renderMode == .wrapping {
                .secondary
            } else {
                .primary
            }
        } else {
            .none
        }
    }
}
