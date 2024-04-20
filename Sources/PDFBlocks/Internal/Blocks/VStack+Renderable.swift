/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension VStack: Renderable {
    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(allowPageWrap: true)[keyPath: keypath]
    }

    func layoutBlocks(_ blocks: [any Renderable], context: Context, environment: EnvironmentValues, proposedSize: Proposal) -> ([CGSize]) {
        let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
        let layoutSize = CGSize(width: proposedSize.width, height: proposedSize.height - fixedSpacing)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: layoutSize) }
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
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposal: averageSize)
            unsizedDict[key] = nil
        }
        // Size the remaining blocks.
        for (key, _) in unsizedDict.sorted(by: { $0.key < $1.key }) {
            let sumSizedHeight = sizedDict.map(\.value.max.height).reduce(0, +)
            let averageHeight = (proposedSize.height - fixedSpacing - sumSizedHeight) / CGFloat(unsizedDict.count)
            let averageSize = CGSize(width: proposedSize.width, height: averageHeight)
            sizedDict[key] = blocks[key].sizeFor(context: context, environment: environment, proposal: averageSize)
            unsizedDict[key] = nil
        }
        //  Return results. I don't like to use !, but here if it crashes, it should crash.
        return blocks.indices.map { sizedDict[$0]!.max }
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
        environment.layoutAxis = .vertical
        if allowWrap {
            if environment.renderMode == .wrapping {
                var height = 0.0
                for (offset, block) in content.getRenderables(environment: environment).enumerated() {
                    let remainingSize = CGSize(width: proposal.width, height: proposal.height - height)
                    let spacing = offset == 0 ? 0 : spacing.fixedPoints
                    let size = block.sizeFor(context: context, environment: environment, proposal: remainingSize)
                    // TODO: check for flex
                    if height + size.max.height + spacing > proposal.height {
                        break
                    } else {
                        height += size.max.height + spacing
                    }
                }
                return BlockSize(CGSize(width: proposal.width, height: height))
            } else {
                return BlockSize(proposal)
            }
        } else {
            let blocks = content.getRenderables(environment: environment)
            let sizes = layoutBlocks(blocks, context: context, environment: environment, proposedSize: proposal)
            let fixedSpacing = spacing.fixedPoints * CGFloat(blocks.count - 1)
            let maxWidth = sizes.map(\.width).reduce(0.0, max)
            let sumMaxHeight = sizes.map(\.height).reduce(0, +)
            let sumMinHeight = sizes.map(\.height).reduce(0.0, +)
            if case .flex = spacing {
                return .init(min: .init(width: maxWidth, height: min(sumMinHeight + fixedSpacing, proposal.height)),
                             max: .init(width: maxWidth, height: proposal.height))
            } else {
                return .init(min: .init(width: maxWidth, height: min(sumMinHeight + fixedSpacing, proposal.height)),
                             max: .init(width: maxWidth, height: min(sumMaxHeight + fixedSpacing, proposal.height)))
            }
        }
    }

    func wrappingModeRender(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        guard context.renderer.layer == context.renderer.renderLayer else {
            return nil
        }
        print("VStack.wrappingModeRender", rect)
        var blocks = content.getRenderables(environment: environment)
        var dy: CGFloat = 0
        for (offset, block) in blocks.enumerated() {
            print("block ", offset)
            let proposal = CGSize(width: rect.size.width, height: rect.size.height - dy)
            let size = block.sizeFor(context: context, environment: environment, proposal: proposal)
            let dx: CGFloat = switch alignment {
            case .leading:
                0
            case .center:
                (rect.width - size.max.width) / 2
            case .trailing:
                rect.width - size.max.width
            }
            if size.min.height + dy <= rect.height {
                let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size.max)
                let remainder = block.render(context: context, environment: environment, rect: renderRect)
                if let remainder {
                    blocks[0] = remainder
                    return VStack<ArrayBlock>(alignment: alignment, spacing: spacing, allowWrap: allowWrap, content: { ArrayBlock(blocks: blocks) })
                } else {
                    dy += size.max.height + spacing.fixedPoints
                }
            } else {
                print("VStack.returning remainder")
                return VStack<ArrayBlock>(alignment: alignment, spacing: spacing, allowWrap: allowWrap, content: { ArrayBlock(blocks: blocks) })
            }
            blocks = blocks.dropFirst().map { $0 }
        }
        return nil
    }

    func primaryWrappingModeRender(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var blocks = content.getRenderables(environment: environment)
        var dy: CGFloat = 0
        while blocks.count > 0 {
            let block = blocks[0]
            let size = block.sizeFor(context: context, environment: environment, proposal: rect.size)
            let dx: CGFloat = switch alignment {
            case .leading:
                0
            case .center:
                (rect.width - size.max.width) / 2
            case .trailing:
                rect.width - size.max.width
            }
            if dy == 0 || (size.min.height + dy <= rect.height) {
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

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.layoutAxis = .vertical
        if allowWrap {
            if environment.renderMode == .wrapping {
                // This is a secondary page wrapping block
                return wrappingModeRender(context: context, environment: environment, rect: rect)
            } else {
                // This is a primary page wrapping block
                context.renderer.setLayer(2)
                context.setPageWrapRect(rect)
                guard context.multiPagePass == nil else {
                    return nil
                }
                print("VStack.setting multipageRender")
                context.multiPagePass = {
                    environment.renderMode = .wrapping
                    print("VStack.conducting multipageRender")
                    primaryWrappingModeRender(context: context, environment: environment, rect: rect)
                }
                return nil
            }
        } else {
            // Atomic Rendering
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
            return nil
        }
    }
}

// Need IndexPointer to Data
// Stack Pointer: Group 1: Header, Data: D. It could only restart if Group Headers and Footers are atomic.? What if footer was replaced by remainder?
