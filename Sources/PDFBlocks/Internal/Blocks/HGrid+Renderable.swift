/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Algorithms
import Foundation

// A Grid takes up its full width
extension HGrid: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        if allowPageWrap {
            if environment.renderMode == .wrapping {
                return BlockSize(width: proposedSize.width, height: 0)
            } else {
                return BlockSize(proposedSize)
            }
        } else {
            let blocks = content.getRenderables(environment: environment)
            let cellWidth = (proposedSize.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
            let cellSize = CGSize(width: cellWidth, height: .infinity)
            let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposedSize: cellSize) }
            let rows = sizes.map(\.max.height).chunks(ofCount: columnCount)
            let height = rows.map { $0.reduce(0, max) }.reduce(0, +) + Double(rows.count - 1) * rowSpacing.points
            return BlockSize(width: proposedSize.width, height: height)
        }
    }

    func wrappingModeRender(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let blocks = content.getRenderables(environment: environment)
        let cellWidth = (rect.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
        let cellSize = CGSize(width: cellWidth, height: .infinity)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposedSize: cellSize) }
        let rows = zip(blocks, sizes).map { $0 }.chunks(ofCount: columnCount)
        for (offset, row) in rows.enumerated() {
            if offset > 0 {
                context.advanceMultipageCursor(rowSpacing.points)
            }
            let rowHeight = row.map(\.1.max.height).reduce(0, max)
            context.renderMultipageContent(rect: rect, height: rowHeight) { rowRect in
                var dx = 0.0
                for (block, size) in row {
                    let cellRect = CGRect(origin: rowRect.origin.offset(dx: dx, dy: 0),
                                          size: .init(width: cellWidth, height: rowHeight))
                    let renderRect = cellRect.rectInCenter(size: size.max)
                    block.render(context: context, environment: environment, rect: renderRect)
                    dx += cellWidth + columnSpacing.points
                }
            }
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.layoutAxis = .horizontal
        if allowPageWrap {
            if environment.renderMode == .wrapping {
                // This is a secondary page wrapping block
                wrappingModeRender(context: context, environment: environment, rect: rect)
            } else {
                // This is a primary page wrapping block
                context.renderer.setLayer(2)
                context.setPageWrapRect(rect)
                guard context.multiPagePass == nil else {
                    return
                }
                context.multiPagePass = {
                    environment.renderMode = .wrapping
                    wrappingModeRender(context: context, environment: environment, rect: rect)
                }
            }
        } else {
            let blocks = content.getRenderables(environment: environment)
            let cellWidth = (rect.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
            let cellSize = CGSize(width: cellWidth, height: rect.height)
            let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposedSize: cellSize) }
            let rows = zip(blocks, sizes).map { $0 }.chunks(ofCount: columnCount)
            var dy = 0.0
            for row in rows {
                var dx = 0.0
                for (block, size) in row {
                    let cellRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy),
                                          size: .init(width: cellWidth, height: size.max.height))
                    let renderRect = cellRect.rectInCenter(size: size.max)
                    block.render(context: context, environment: environment, rect: renderRect)
                    dx += cellWidth + columnSpacing.points
                }
                dy += row.map(\.1.max.height).reduce(0, max) + rowSpacing.points
            }
        }
    }

    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(allowPageWrap: allowPageWrap)[keyPath: keypath]
    }
}
