/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Columns: Renderable {
    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(wrapContents: wrap)[keyPath: keypath]
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
        environment.columnsLayout = true
        environment.layoutAxis = .vertical
        switch wrapMode(context: context, environment: environment) {
        case .atomic:
            environment.renderMode = .wrapping
            let blocks = content.getRenderables(environment: environment)
            let height = evenHeight(context: context, environment: environment, blocks: blocks, proposal: proposal)
            return BlockSize(width: proposal.width, height: height)
        case .secondary:
            environment.renderMode = .wrapping
            let blocks = content.getRenderables(environment: environment)
            let height = evenHeight(context: context, environment: environment, blocks: blocks, proposal: proposal)
            return BlockSize(width: proposal.width, height: min(height, proposal.height))
        case .primary:
            environment.renderMode = .wrapping
            return BlockSize(min: CGSize(width: proposal.width, height: 0), max: proposal)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.columnsLayout = true
        environment.layoutAxis = .vertical
        switch wrapMode(context: context, environment: environment) {
        case .atomic:
            environment.renderMode = .wrapping
            renderAtomic(context: context, environment: environment, rect: rect)
            return nil
        case .secondary:
            environment.renderMode = .wrapping
            return renderSecondary(context: context, environment: environment, rect: rect)
        case .primary:
            environment.renderMode = .wrapping
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
    func wrapMode(context _: Context, environment: EnvironmentValues) -> WrapMode {
        if wrap {
            if environment.renderMode == .wrapping {
                .secondary
            } else {
                .primary
            }
        } else {
            .atomic
        }
    }

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
                        while let first = blocks.first, first.isSpacer(context: context, environment: environment) {
                            blocks = Array(blocks.dropFirst())
                        }
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
        while blocks.count > 0 {
            let height = evenHeight(context: context, environment: environment, blocks: blocks, proposal: rect.size)
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
                        while let first = blocks.first, first.isSpacer(context: context, environment: environment) {
                            blocks = Array(blocks.dropFirst())
                        }
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
                if (dy == 0) || (dy + size.max.height ~<= rect.height) {
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
            return Columns<ArrayBlock>(count: count, spacing: spacing, wrap: wrap, content: { ArrayBlock(blocks: blocks) })
        } else {
            return nil
        }
    }

    // evenHeight finds a height for Columns that distributes content across the columns evenly, with the first column
    // being the longest if possible.
    func evenHeight(context: Context, environment: EnvironmentValues, blocks: [any Renderable], proposal: Proposal) -> CGFloat {
        let wrapMode = wrapMode(context: context, environment: environment)
        let columnWidth = (proposal.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
        let blockProposal = CGSize(width: columnWidth, height: .infinity)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: blockProposal) }
        let contentHeight = min(CGFloat(count) * proposal.height, sizes.map(\.max.height).reduce(0, +))
        let averageHeight = ceil(contentHeight / CGFloat(count))
        var pass = 0
        if wrapMode == .primary, averageHeight ~>= proposal.height {
            return proposal.height
        } else {
            var proposedHeight = averageHeight
            while true {
                pass += 1
                if pass > 20 {
                    // Prevent endless loops
                    return proposal.height
                }
                let columnSize = CGSize(width: columnWidth, height: proposedHeight)
                let excess = excessHeight(context: context, environment: environment, proposal: columnSize, blocks: blocks)
                if excess == 0 {
                    let exactProposal = CGSize(width: columnWidth, height: proposedHeight)
                    return exactHeight(context: context, environment: environment, proposal: exactProposal, blocks: blocks)
                } else {
                    proposedHeight += ceil(excess / CGFloat(count))
                }
            }
        }
    }

    // excessHeight takes a proposed height from evenHeight and returns a positive value if there is more content than will
    // fit in the proposal or a negative value if the content does not fill all three columns.
    func excessHeight(context: Context, environment: EnvironmentValues, proposal: Proposal, blocks: [any Renderable]) -> CGFloat {
        var mutableBlocks = blocks
        var column = 0
        var columnHeight = 0.0
        while mutableBlocks.count > 0, column <= count - 1 {
            let block = mutableBlocks[0]
            let blockProposal = CGSize(width: proposal.width, height: proposal.height - columnHeight)
            let size = block.sizeFor(context: context, environment: environment, proposal: blockProposal)
            if size.max.height ~> blockProposal.height {
                column += 1
                columnHeight = 0
            } else {
                columnHeight += size.max.height
                let remainder = block.remainder(context: context, environment: environment, size: blockProposal)
                if let remainder, size.max.height > 0 {
                    mutableBlocks[0] = remainder
                    column += 1
                    columnHeight = 0
                } else {
                    mutableBlocks = mutableBlocks.dropFirst().map { $0 }
                }
            }
        }
        let excessProposal = CGSize(width: proposal.width, height: .infinity)
        let excessSizes = mutableBlocks.map { $0.sizeFor(context: context, environment: environment, proposal: excessProposal) }
        let result = excessSizes.map(\.max.height).reduce(0, +)
        if column < count - 1, result == 0 {
            return -proposal.height / CGFloat(count)
        } else {
            return result
        }
    }

    // exactHeight takes the proposed result from evenHeight when a height is found with zero excess. It then uses that to
    // return the exact height needed for an even column layout.
    func exactHeight(context: Context, environment: EnvironmentValues, proposal: Proposal, blocks: [any Renderable]) -> CGFloat {
        var mutableBlocks = blocks
        var column = 0
        var columnHeight = 0.0
        var result = 0.0
        while mutableBlocks.count > 0, column <= count - 1 {
            let block = mutableBlocks[0]
            let blockProposal = CGSize(width: proposal.width, height: proposal.height - columnHeight)
            let size = block.sizeFor(context: context, environment: environment, proposal: blockProposal)
            if (size.max.height + columnHeight) ~> proposal.height {
                column += 1
                columnHeight = 0
            } else {
                columnHeight += size.max.height
                result = max(result, columnHeight)
                let remainder = block.remainder(context: context, environment: environment, size: blockProposal)
                if let remainder, size.max.height > 0 {
                    mutableBlocks[0] = remainder
                    column += 1
                    columnHeight = 0
                } else {
                    mutableBlocks = mutableBlocks.dropFirst().map { $0 }
                }
            }
        }
        return result
    }
}
