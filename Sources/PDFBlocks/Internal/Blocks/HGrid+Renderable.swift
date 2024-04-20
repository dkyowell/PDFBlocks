/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Algorithms
import Foundation

// A Grid takes up its full width
extension HGrid: Renderable {
    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(allowPageWrap: allowWrap)[keyPath: keypath]
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        if environment.renderMode == .measured, allowWrap {
            return BlockSize(proposal)
        } else {
            let blocks = content.getRenderables(environment: environment)
            let cellWidth = (proposal.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
            let cellSize = CGSize(width: cellWidth, height: .infinity)
            let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: cellSize) }
            let rows = sizes.map(\.max.height).chunks(ofCount: columnCount)
            let height = rows.map { $0.reduce(0, max) }.reduce(0, +) + Double(rows.count - 1) * rowSpacing.points
            let minSize = CGSize.zero
            let maxSize = CGSize(width: proposal.width, height: min(height, proposal.height))
            return BlockSize(min: minSize, max: maxSize)
        }
    }

    func render1(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
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

    func render2(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
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
                                         content: { ArrayBlock(blocks: blocks) })
            }
        }
        return nil
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.layoutAxis = .horizontal
        if environment.renderMode == .measured, allowWrap {
            context.renderer.setLayer(2)
            context.setPageWrapRect(rect)
            guard context.multiPagePass == nil else {
                return nil
            }
            context.multiPagePass = {
                environment.renderMode = .wrapping
                _ = render1(context: context, environment: environment, rect: rect)
            }
            return nil
        } else {
            return render2(context: context, environment: environment, rect: rect)
        }
    }
}
