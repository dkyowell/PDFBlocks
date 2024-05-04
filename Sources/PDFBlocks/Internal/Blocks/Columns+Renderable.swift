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
        environment.layoutAxis = .vertical
        switch wrapMode(context: context, environment: environment) {
        case .none:
            let columnWidth = (proposal.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
            let blockProposal = CGSize(width: columnWidth, height: .infinity)
            let blocks = content.getRenderables(environment: environment)
                .flatMap { $0.decompose(context: context, environment: environment, proposal: blockProposal) }
            let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: blockProposal) }
            let height = heightForEvenColumns(sizes: sizes, firstColumnCount: nil)
            return BlockSize(min: CGSize(width: proposal.width, height: height),
                             max: CGSize(width: proposal.width, height: height))
        case .secondary:
            let columnWidth = (proposal.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
            let blockProposal = CGSize(width: columnWidth, height: .infinity)
            let blocks = content.getRenderables(environment: environment)
                .flatMap { $0.decompose(context: context, environment: environment, proposal: blockProposal) }
            let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: blockProposal) }
            let height = heightForEvenColumns(sizes: sizes, firstColumnCount: nil)
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
    func renderAtomic(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let columnWidth = (rect.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
        var blocks = content.getRenderables(environment: environment)
        while blocks.count > 0 {
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
        }
    }

    func renderPrimary(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let columnWidth = (rect.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
        var blocks = content.getRenderables(environment: environment)
        while blocks.count > 0 {
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
                    if rect.minY + dy + size.min.height < rect.maxY {
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
            if pageWrap {
                if blocks.count > 0 {
                    context.endPage()
                    context.beginPage()
                }
            } else {
                return
            }
        }
    }

    func renderSecondary(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let columnWidth = (rect.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
        var blocks = content.getRenderables(environment: environment)
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

    func heightForEvenColumns(sizes: [BlockSize], firstColumnCount: Int?) -> CGFloat {
        let contentHeight = sizes.map(\.min.height).reduce(0, +)
        var workingHeight = contentHeight / CGFloat(count)
        var workingColumn = 0
        var maxY = 0.0
        var newFirstColumnCount = firstColumnCount
        for (offset, size) in sizes.enumerated() {
            if workingColumn == 0, let firstColumnCount {
                if offset <= firstColumnCount - 1 {
                    maxY += size.min.height
                } else {
                    workingColumn += 1
                    workingHeight = maxY
                    maxY = size.min.height
                }
            } else {
                if maxY + size.min.height ~<= workingHeight {
                    maxY += size.min.height
                    if workingColumn == 0 {
                        newFirstColumnCount = offset + 1
                    }
                } else {
                    if workingColumn < count - 1 {
                        maxY = size.min.height
                        workingColumn += 1
                    } else {
                        if let newFirstColumnCount {
                            return heightForEvenColumns(sizes: sizes, firstColumnCount: newFirstColumnCount + 1)
                        }
                    }
                }
            }
        }
        return workingHeight
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
