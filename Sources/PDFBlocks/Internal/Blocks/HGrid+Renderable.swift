/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Algorithms
import Foundation

extension HGrid {
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

// A Grid takes up its full width
extension HGrid: Renderable {
    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(allowWrap: allowWrap)[keyPath: keypath]
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        print("HGrid.sizeFor", proposal, wrapMode(context: context, environment: environment))
        var environment = environment
        environment.layoutAxis = .horizontal
        switch wrapMode(context: context, environment: environment) {
        case .none:
            let blocks = content.getRenderables(environment: environment)
            let cellWidth = (proposal.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
            let cellSize = CGSize(width: cellWidth, height: .infinity)
            let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: cellSize) }
            let rows = sizes.map(\.max.height).chunks(ofCount: columnCount)
            let height = rows.map { $0.reduce(0, max) }.reduce(0, +) + Double(rows.count - 1) * rowSpacing.points
            let minSize = CGSize.zero
            let maxSize = CGSize(width: proposal.width, height: min(height, proposal.height))
            return BlockSize(min: minSize, max: maxSize)
        case .primary:
            return BlockSize(min: CGSize(width: proposal.width, height: 0), max: proposal)
        case .secondary:
            print("HGrid.secondary", proposal)
            let blocks = content.getRenderables(environment: environment)
            let cellWidth = (proposal.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
            let cellSize = CGSize(width: cellWidth, height: .infinity)
            let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: cellSize) }
            let rows = sizes.map(\.max.height).chunks(ofCount: columnCount)
            let height = rows.map { $0.reduce(0, max) }.reduce(0, +) + Double(rows.count - 1) * rowSpacing.points
            let maxSize = CGSize(width: proposal.width, height: min(height, proposal.height))
            // TODO: changed min to maxSize. Is this right? Seems to work.
            return BlockSize(min: maxSize, max: maxSize)
        }
    }

    func contentSize(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
        environment.layoutAxis = .horizontal
        switch wrapMode(context: context, environment: environment) {
        case .none:
            let blocks = content.getRenderables(environment: environment)
            let cellWidth = (proposal.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
            let cellSize = CGSize(width: cellWidth, height: .infinity)
            let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: cellSize) }
            let rows = sizes.map(\.max.height).chunks(ofCount: columnCount)
            let height = rows.map { $0.reduce(0, max) }.reduce(0, +) + Double(rows.count - 1) * rowSpacing.points
            let minSize = CGSize.zero
            let maxSize = CGSize(width: proposal.width, height: height)
            return BlockSize(min: minSize, max: maxSize)
        case .primary, .secondary:
            return BlockSize(proposal)
        }
    }

    func renderPrimaryWrap(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var blocks = content.getRenderables(environment: environment)
        let cellWidth = (rect.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
        let cellSize = CGSize(width: cellWidth, height: rect.height)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: cellSize) }
        let rows = zip(blocks, sizes).map { $0 }.chunks(ofCount: columnCount)
        var dy = 0.0
        for (offset, row) in rows.enumerated() {
            var dx = 0.0
            let rowHeight = row.map(\.1.max.height).reduce(0, max)
            if rect.height < rowHeight + dy {
                context.endPage()
                context.beginPage()
                dy = 0
            }
            if rect.height >= rowHeight + dy {
                for (block, size) in row {
                    let cellRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy),
                                          size: .init(width: cellWidth, height: size.max.height))
                    let renderRect = cellRect.rectInCenter(size: size.max)
                    block.render(context: context, environment: environment, rect: renderRect)
                    dx += cellWidth + columnSpacing.points
                }
                dy += rowHeight + rowSpacing.points
                blocks = blocks.dropFirst(columnCount).map { $0 }
            } else {}
        }
        return nil
    }

    func renderSecondaryWrap(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var blocks = content.getRenderables(environment: environment)
        let cellWidth = (rect.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
        let cellSize = CGSize(width: cellWidth, height: rect.height)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: cellSize) }
        let rows = zip(blocks, sizes).map { $0 }.chunks(ofCount: columnCount)
        var dy = 0.0
        for row in rows {
            var dx = 0.0
            let rowHeight = row.map(\.1.max.height).reduce(0, max)
            if rect.height >= rowHeight + dy { // TODO: OR...
                for (block, size) in row {
                    let cellRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy),
                                          size: .init(width: cellWidth, height: size.max.height))
                    let renderRect = cellRect.rectInCenter(size: size.max)
                    block.render(context: context, environment: environment, rect: renderRect)
                    dx += cellWidth + columnSpacing.points
                }
                dy += rowHeight + rowSpacing.points
                blocks = blocks.dropFirst(columnCount).map { $0 }
            } else {
                return HGrid<ArrayBlock>(columnCount: columnCount,
                                         columnSpacing: columnSpacing,
                                         rowSpacing: rowSpacing,
                                         allowWrap: allowWrap,
                                         content: { ArrayBlock(blocks: blocks) })
            }
        }
        return nil
    }

    func renderAtomic(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let blocks = content.getRenderables(environment: environment)
        let cellWidth = (rect.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
        let cellSize = CGSize(width: cellWidth, height: rect.height)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: cellSize) }
        let rows = zip(blocks, sizes).map { $0 }.chunks(ofCount: columnCount)
        let contentSize = contentSize(context: context, environment: environment, proposal: rect.size)
        var dy = (rect.height - contentSize.max.height) / 2
        for row in rows {
            var dx = 0.0
            let rowHeight = row.map(\.1.max.height).reduce(0, max)
            for (block, size) in row {
                let cellRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy),
                                      size: .init(width: cellWidth, height: size.max.height))
                let renderRect = cellRect.rectInCenter(size: size.max)
                block.render(context: context, environment: environment, rect: renderRect)
                dx += cellWidth + columnSpacing.points
            }
            dy += rowSpacing.points + rowHeight
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.layoutAxis = .horizontal
        switch wrapMode(context: context, environment: environment) {
        case .none:
            print("HGrid.render.none", rect.size)
            renderAtomic(context: context, environment: environment, rect: rect)
            return nil
        case .primary:
            print("HGrid.render.primary", rect.size)
            context.renderer.setLayer(2)
            context.setPageWrapRect(rect)
            if context.multiPagePass == nil {
                context.multiPagePass = {
                    environment.renderMode = .wrapping
                    _ = renderPrimaryWrap(context: context, environment: environment, rect: rect)
                }
            }
            return nil
        case .secondary:
            print("HGrid.render.secondary", rect.size)
            return renderSecondaryWrap(context: context, environment: environment, rect: rect)
        }

//        if environment.renderMode == .measured, allowWrap {
//            context.renderer.setLayer(2)
//            context.setPageWrapRect(rect)
//            guard context.multiPagePass == nil else {
//                return nil
//            }
//            context.multiPagePass = {
//                environment.renderMode = .wrapping
//                _ = render1(context: context, environment: environment, rect: rect)
//            }
//            return nil
//        } else {
//            return render2(context: context, environment: environment, rect: rect)
//        }
    }
}
