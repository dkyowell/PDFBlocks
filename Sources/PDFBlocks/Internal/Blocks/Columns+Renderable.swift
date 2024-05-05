/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Columns: Renderable {
    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(allowWrap: pageWrap)[keyPath: keypath]
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
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
        environment.textContinuationMode = true
        environment.layoutAxis = .vertical
        switch wrapMode(context: context, environment: environment) {
        case .none:
            renderAtomic(context: context, environment: environment, rect: rect)
            return nil
        case .secondary:
            let blocks = content.getRenderables(environment: environment)
            return renderSecondary(context: context, environment: environment, blocks: blocks, rect: rect)
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
            while rect.minY + dy < rect.maxY, blocks.isEmpty == false {
                let block = blocks[0]
                let remainingSize = CGSize(width: columnWidth, height: rect.height - dy)
                let size = block.sizeFor(context: context, environment: environment, proposal: remainingSize)
                if dy + size.min.height ~<= rect.height {
                    let renderRect = CGRect(x: xPos, y: rect.minY + dy, width: columnWidth, height: size.max.height)
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
        while blocks.count > 0 {
            let height = heightForEvenColumns(context: context, environment: environment, blocks: blocks, proposal: rect.size)
            let renderRect = if context.pageNo > 1 {
                CGRect(origin: rect.origin, size: .init(width: rect.width, height: height))
            } else {
                CGRect(origin: rect.origin, size: .init(width: rect.width, height: height))
            }
            if let remainder = renderSecondary(context: context, environment: environment, blocks: blocks, rect: renderRect) {
                if let columns = remainder as? Columns<ArrayBlock> {
                    blocks = columns.content.getRenderables(environment: environment)
                    context.endPage()
                    context.beginPage()
                } else {
                    return
                }
            } else {
                return
            }
        }
    }

    func renderSecondary(context: Context, environment: EnvironmentValues, blocks: [any Renderable], rect: CGRect) -> (any Renderable)? {
        var blocks = blocks
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
                if dy + size.min.height ~<= rect.height {
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
            return Columns<ArrayBlock>(count: count, spacing: spacing, pageWrap: pageWrap, content: { ArrayBlock(blocks: blocks) })
        } else {
            return nil
        }
    }

    func heightForEvenColumns(context: Context, environment: EnvironmentValues, blocks: [any Renderable], proposal: Proposal) -> CGFloat {
        let columnWidth = (proposal.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
        let blockProposal = CGSize(width: columnWidth, height: .infinity)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: blockProposal) }
        let contentHeight = sizes.map(\.min.height).reduce(0, +)
        let averageHeight = contentHeight / CGFloat(count)
        if averageHeight > proposal.height {
            return proposal.height
        } else {
            var addition = 0.0
            while averageHeight + addition < proposal.height {
                // Perform layout
                var blocks = blocks
                var column = 0
                var columnHeight = 0.0
                while blocks.count > 0 {
                    let block = blocks[0]
                    let proposal = CGSize(width: columnWidth, height: averageHeight + addition - columnHeight)
                    let size = block.sizeFor(context: context, environment: environment, proposal: proposal)
                    let remainder = block.remainder(context: context, environment: environment, size: proposal)
                    if columnHeight + size.min.height ~<= averageHeight + addition {
                        columnHeight += size.min.height
                        if let remainder {
                            blocks[0] = remainder
                        } else {
                            blocks = blocks.dropFirst().map { $0 }
                        }
                    } else {
                        column += 1
                        columnHeight = 0.0
                    }
                    if column == count {
                        addition += 2
                        break
                    }
                }
                if blocks.count == 0 {
                    break
                }
            }
            return averageHeight + addition
        }
    }

    func wrapMode(context _: Context, environment: EnvironmentValues) -> WrapMode {
        if pageWrap {
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
