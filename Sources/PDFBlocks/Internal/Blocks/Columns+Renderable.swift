/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// TODO: Some layouts can result in the first column not being the longest. This will happen when column elements are
// of uneven sizes and subsequent columns fit withing the proposed size, but the first column does not fill up its
// proposed size. See Example+Columns3
extension Columns: Renderable {
    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(wrapContents: wrapContents)[keyPath: keypath]
    }
    
    // TODO: Needs Remainder

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
        environment.columnsLayout = true
        environment.textContinuationMode = true
        environment.layoutAxis = .vertical
        switch wrapMode(context: context, environment: environment) {
        case .none:
            let blocks = content.getRenderables(environment: environment)
            let height = heightForEvenColumns(context: context, environment: environment, blocks: blocks, proposal: proposal)
            return BlockSize(min: CGSize(width: proposal.width, height: height),
                             max: CGSize(width: proposal.width, height: height))
        case .secondary:
            let blocks = content.getRenderables(environment: environment)
            let height = heightForEvenColumns(context: context, environment: environment, blocks: blocks, proposal: proposal)
            return BlockSize(min: CGSize(width: proposal.width, height: min(height, proposal.height)),
                             max: CGSize(width: proposal.width, height: min(height, proposal.height)))
        case .primary:
            return BlockSize(min: .init(width: proposal.width, height: 0), max: proposal)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.columnsLayout = true
        environment.textContinuationMode = true
        environment.layoutAxis = .vertical
        switch wrapMode(context: context, environment: environment) {
        case .none:
            renderAtomic(context: context, environment: environment, rect: rect)
            return nil
        case .secondary:
            return renderSecondary(context: context, environment: environment, rect: rect)
        case .primary:
            context.renderer.setLayer(2)
            context.setPageWrapRect(rect)
            if context.multiPagePass == nil {
                context.multiPagePass = {
                    environment.renderMode = .wrapping
                    renderPrimary(context: context, environment: environment, rect: rect)
                }
            }
            return nil
        }
    }
}

extension Columns {
    // TODO: Determine how atomic render should handle overflow. Presently it clips overflow.
    func renderAtomic(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let columnWidth = (rect.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
        var blocks = content.getRenderables(environment: environment)
        for column in 0 ..< count {
            let xPos = rect.minX + (columnWidth + spacing.points) * CGFloat(column)
            var dy: CGFloat = 0
            var pass = 0
            while rect.minY + dy < rect.maxY, blocks.isEmpty == false {
                pass += 1
                let block = blocks[0]
                let remainingSize = CGSize(width: columnWidth, height: rect.height - dy)
                let size = block.sizeFor(context: context, environment: environment, proposal: remainingSize)
                if (pass == 1) || (dy + size.max.height ~<= rect.height) {
                    let renderRect = CGRect(x: xPos, y: rect.minY + dy, width: size.max.width, height: size.max.height)
                    let remainder = block.render(context: context, environment: environment, rect: renderRect)
                    dy += renderRect.height
                    if let remainder {
                        blocks[0] = remainder
                    } else {
                        blocks = blocks.dropFirst().map { $0 }
                    }
                } else {
                    break
                }
            }
        }
    }

    func renderPrimary(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var blocks = content.getRenderables(environment: environment)
        var rect = rect
        print("Columns.renderPrimaryPage", blocks.count)
        while blocks.count > 0 {
            let height = heightForEvenColumns(context: context, environment: environment, blocks: blocks, proposal: rect.size)
            print("height", height)
            let renderRect = CGRect(origin: rect.origin, size: .init(width: rect.width, height: height))
            blocks = renderPrimaryPage(context: context, environment: environment, blocks: blocks, rect: renderRect)
            if blocks.count > 0 {
                context.endPage()
                context.beginPage()
                rect = context.pageWrapRect
            }
        }
    }

    func renderPrimaryPage(context: Context, environment: EnvironmentValues, blocks: [any Renderable], rect: CGRect) -> [any Renderable] {
        var blocks = blocks
        let columnWidth = (rect.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
        for column in 0 ..< count {
            let xPos = rect.minX + (columnWidth + spacing.points) * CGFloat(column)
            var columnHeight = 0.0
            while columnHeight < rect.height, blocks.isEmpty == false {
                let block = blocks[0]
                let remainingSize = CGSize(width: columnWidth, height: rect.height - columnHeight)
                let size = block.sizeFor(context: context, environment: environment, proposal: remainingSize)
                if columnHeight == 0 || (columnHeight + size.max.height ~<= rect.height) {
                    let renderRect = CGRect(x: xPos, y: rect.minY + columnHeight, width: size.max.width, height: size.max.height)
                    let remainder = block.render(context: context, environment: environment, rect: renderRect)
                    columnHeight += renderRect.height
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
        }
        return blocks
    }

    func renderSecondary(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var blocks = content.getRenderables(environment: environment)
        let columnWidth = (rect.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
        for column in 0 ..< count {
            let xPos = rect.minX + (columnWidth + spacing.points) * CGFloat(column)
            var dy: CGFloat = 0
            while rect.minY + dy < rect.maxY, blocks.isEmpty == false {
                guard let block = blocks.first else {
                    break
                }
                blocks = blocks.dropFirst().map { $0 }
                let remainingSize = CGSize(width: columnWidth, height: rect.height - dy)
                let size = block.sizeFor(context: context, environment: environment, proposal: remainingSize)
                if dy + size.max.height ~<= rect.height {
                    let renderRect = CGRect(x: xPos, y: rect.minY + dy, width: columnWidth, height: size.max.height)
                    let remainder = block.render(context: context, environment: environment, rect: renderRect)
                    dy += renderRect.height
                    if let remainder {
                        blocks.insert(remainder, at: 0)
                        break
                    }
                } else {
                    blocks.insert(block, at: 0)
                    break
                }
            }
        }
        if blocks.count > 0 {
            return Columns<ArrayBlock>(count: count, spacing: spacing, wrapContents: wrapContents, content: { ArrayBlock(blocks: blocks) })
        } else {
            return nil
        }
    }
    
    func excessHeight(context: Context, environment: EnvironmentValues, proposal: Proposal, blocks: [any Renderable]) -> CGFloat {
        var mutableBlocks = blocks
        var column = 0
        var columnHeight = 0.0
        while mutableBlocks.count > 0, column <= count - 1 {
            let block = mutableBlocks[0]
            let blockProposal = CGSize(width: proposal.width, height: proposal.height - columnHeight)
            let size = block.sizeFor(context: context, environment: environment, proposal: proposal)
            if (size.max.height + columnHeight) ~> proposal.height {
                column += 1
                columnHeight = 0
            } else {
                columnHeight += size.max.height
                let remainder = block.remainder(context: context, environment: environment, size: blockProposal)
                if let remainder {//}, size.max.height > 0 {
                    mutableBlocks[0] = remainder
                    column += 1
                    columnHeight = 0
                } else {
                    mutableBlocks = mutableBlocks.dropFirst().map { $0 }
                }
            }
        }
        let excessProposal = CGSize(width: proposal.width, height: .infinity)
        let excessSizes = mutableBlocks.map({$0.sizeFor(context: context, environment: environment, proposal: excessProposal)})
        return excessSizes.map({$0.max.height}).reduce(0, +)
    }

    func heightForEvenColumns(context: Context, environment: EnvironmentValues, blocks: [any Renderable], proposal: Proposal) -> CGFloat {
        let columnWidth = (proposal.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
        let blockProposal = CGSize(width: columnWidth, height: .infinity)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: blockProposal) }
        let contentHeight = min(CGFloat(count) * proposal.height, sizes.map(\.max.height).reduce(0, +))
        let averageHeight = ceil(contentHeight / CGFloat(count))
        if averageHeight ~>= proposal.height {
            return proposal.height
        } else {
            var proposedHeight = averageHeight
            while true {
                let columnSize = CGSize(width: columnWidth, height: proposedHeight)
                let excess = excessHeight(context: context, environment: environment, proposal: columnSize, blocks: blocks)
                if excess == 0 {
                    return proposedHeight
                } else {
                    proposedHeight += ceil(excess / CGFloat(count))
                }
            }
        }
    }

    func wrapMode(context _: Context, environment: EnvironmentValues) -> WrapMode {
        if wrapContents {
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
