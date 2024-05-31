/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension VStack: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        if keypath == \.computePageCount {
            let blocks = content.getRenderables(environment: environment)
            let result = blocks.reduce(false) { $0 || $1.computePageCount(context: context, environment: environment) }
            return Trait(computePageCount: result)[keyPath: keypath]
        } else {
            return Trait(wrapContents: wrap)[keyPath: keypath]
        }
    }

    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        var environment = environment
        environment.layoutAxis = .vertical
        var mutableBlocks = content.getRenderables(environment: environment)
        var usedHeight: CGFloat = 0
        for block in mutableBlocks {
            let proposal = CGSize(width: size.width, height: max(0, size.height - usedHeight))
            let blockSize = block.sizeFor(context: context, environment: environment, proposal: proposal)
            if blockSize.max.height ~<= proposal.height {
                let remainder = block.remainder(context: context, environment: environment, size: proposal)
                usedHeight += blockSize.max.height + spacing.fixedPoints
                if let remainder, blockSize.max.height > 0 {
                    mutableBlocks[0] = remainder
                    return VStack<ArrayBlock>(alignment: alignment, spacing: spacing, wrap: wrap, content: { ArrayBlock(blocks: mutableBlocks) })
                } else {
                    mutableBlocks = Array(mutableBlocks.dropFirst())
                }
            } else {
                while let first = mutableBlocks.first, first.isSpacer(context: context, environment: environment) {
                    mutableBlocks = Array(mutableBlocks.dropFirst())
                }
                return VStack<ArrayBlock>(alignment: alignment, spacing: spacing, wrap: wrap, content: { ArrayBlock(blocks: mutableBlocks) })
            }
        }
        return nil
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
        environment.layoutAxis = .vertical
        switch wrapMode(environment: environment) {
        case .atomic:
            let blocks = content.getRenderables(environment: environment)
            let sizes = layoutBlocks(blocks, context: context, environment: environment, proposal: proposal)
            context.layoutCache[cacheId] = sizes
            let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
            let minHightSum = sizes.map(\.min.height).reduce(0, +) + fixedSpacing
            var maxHeightSum = sizes.map(\.max.height).reduce(0, +) + fixedSpacing
            if spacing.isFlexible, maxHeightSum < proposal.height {
                maxHeightSum = proposal.height
            }
            let minWidthMax = sizes.map(\.min.width).reduce(0, max)
            let maxWidthMax = sizes.map(\.max.width).reduce(0, max)
            return BlockSize(min: CGSize(width: minWidthMax, height: minHightSum),
                             max: CGSize(width: maxWidthMax, height: maxHeightSum))
        case .primary:
            return BlockSize(min: CGSize(width: proposal.width, height: 0), max: proposal)
        case .secondary:
            let blocks = content.getRenderables(environment: environment)
            var height = 0.0
            var maxWidth = 0.0
            for (offset, block) in blocks.enumerated() {
                let spacing = offset == 0 ? 0 : spacing.fixedPoints
                let proposal = CGSize(width: proposal.width, height: proposal.height - height - spacing)
                let size = block.sizeFor(context: context, environment: environment, proposal: proposal)
                if offset > 0, size.min.height ~> proposal.height {
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
        switch wrapMode(environment: environment) {
        case .atomic:
            renderAtomic(context: context, environment: environment, rect: rect)
            return nil
        case .primary:
            context.renderer.setLayer(2)
            context.setPageWrapRect(rect)
            if context.multiPagePass == nil {
                context.multiPagePass = {
                    renderPrimary(context: context, environment: environment, rect: rect)
                }
            }
            return nil
        case .secondary:
            return renderSecondary(context: context, environment: environment, rect: rect)
        }
    }
}

extension VStack {
    func renderAtomic(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.layoutAxis = .vertical
        let blocks = content.getRenderables(environment: environment)
        let sizes = (context.layoutCache[cacheId] as? [BlockSize]) ??
            layoutBlocks(blocks, context: context, environment: environment, proposal: rect.size)
        // let sizes = atomicLayoutBlocks(blocks, context: context, environment: environment, proposal: rect.size)
        let space: CGFloat
        switch spacing {
        case let .flex(size):
            let sumHeight = sizes.map(\.max.height).reduce(0, +)
            space = max(size.points, (rect.height - sumHeight) / CGFloat(blocks.count - 1))
        case let .fixed(size):
            space = size.points
        }
        var dy = 0.0
        for (block, size) in zip(blocks, sizes) {
            let dx: CGFloat = switch alignment {
            case .leading:
                0
            case .center:
                (rect.width - size.max.width) / 2
            case .trailing:
                rect.width - size.max.width
            }
            let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size.max)
            block.render(context: context, environment: environment, rect: renderRect)
            dy += size.max.height + space
        }
    }

    // Render all content, starting new pages as necessary, until complete.
    func renderPrimary(context: Context, environment: EnvironmentValues, rect _: CGRect) {
        var environment = environment
        environment.layoutAxis = .vertical
        environment.renderMode = .wrapping
        var blocks = content.getRenderables(environment: environment)
        var dy: CGFloat = 0
        while blocks.count > 0 {
            let rect = context.pageWrapRect
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
            // Render at least one element per pass.
            if (dy == 0) || (size.max.height + dy ~<= rect.height), remainingSize.height > 0 {
                let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size.max)
                let remainder = block.render(context: context, environment: environment, rect: renderRect)
                dy += size.max.height + spacing.fixedPoints
                if let remainder {
                    blocks[0] = remainder
                    context.endPage()
                    context.beginPage()
                    dy = 0
                    while let first = blocks.first, first.isSpacer(context: context, environment: environment) {
                        blocks = Array(blocks.dropFirst())
                    }
                } else {
                    blocks = Array(blocks.dropFirst())
                }
            } else {
                context.endPage()
                context.beginPage()
                dy = 0
                while let first = blocks.first, first.isSpacer(context: context, environment: environment) {
                    blocks = Array(blocks.dropFirst())
                }
            }
        }
    }

    // Render as much content as fits into rect and return the remainder.
    func renderSecondary(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.layoutAxis = .vertical
        var blocks = content.getRenderables(environment: environment)
        var dy: CGFloat = 0
        var pass = 0
        while blocks.count > 0, dy ~<= rect.height {
            pass += 1
            let block = blocks[0]
            let proposal = CGSize(width: rect.size.width, height: rect.size.height - dy)
            let size = block.sizeFor(context: context, environment: environment, proposal: proposal)
            if (dy == 0 && rect.minY == context.pageWrapRect.minY) || size.max.height ~<= proposal.height, proposal.height > 0 {
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
                dy += size.max.height + spacing.fixedPoints
                if let remainder {
                    blocks[0] = remainder
                    break
                } else {
                    blocks = Array(blocks.dropFirst())
                }
            } else {
                break
            }
        }
        if blocks.count == 0 {
            return nil
        } else {
            while let first = blocks.first, first.isSpacer(context: context, environment: environment) {
                blocks = Array(blocks.dropFirst())
            }
            return VStack<ArrayBlock>(alignment: alignment, spacing: spacing, wrap: wrap, content: { ArrayBlock(blocks: blocks) })
        }
    }

    func layoutBlocks(_ blocks: [any Renderable], context: Context, environment: EnvironmentValues, proposal: Proposal) -> [BlockSize] {
        let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
        let adjustedHeight = proposal.height - fixedSpacing
        let adjustedProposal = CGSize(width: proposal.width, height: adjustedHeight)
        // Size all blocks using the adjustedWidth of the proposal
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: adjustedProposal) }
        var unsizedDict = sizes.enumerated().reduce(into: [:]) { $0[$1.offset] = $1.element }
        var sizedDict = [Int: BlockSize]()
        // Sorted by width, size the non-flexible blocks using the average remaining width
        for (key, _) in unsizedDict.filter({ $0.value.vFlexible == false }).sorted(by: { $0.value.max.height < $1.value.max.height }) {
            let sumSizedHeight = sizedDict.map(\.value.max.height).reduce(0, +)
            let averageHeight = max(0, (adjustedHeight - sumSizedHeight) / CGFloat(unsizedDict.count))
            let averageSize = CGSize(width: proposal.width, height: averageHeight)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposal: averageSize)
            unsizedDict[key] = nil
        }
        // Sorted by width, layout the remaining blocks using the average remaining width
        for (key, _) in unsizedDict.sorted(by: { $0.value.max.height < $1.value.max.height }) {
            let sumSizedHeight = sizedDict.map(\.value.max.height).reduce(0, +)
            let averageHeight = max(0, (adjustedHeight - sumSizedHeight) / CGFloat(unsizedDict.count))
            let averageSize = CGSize(width: proposal.width, height: averageHeight)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposal: averageSize)
            unsizedDict[key] = nil
        }
        return blocks.indices.map { BlockSize(sizedDict[$0]!.max) }
    }

    func wrapMode(environment: EnvironmentValues) -> WrapMode {
        if wrap {
            if environment.renderMode == .wrapping || environment.columnsLayout {
                .secondary
            } else {
                .primary
            }
        } else {
            .atomic
        }
    }
}
