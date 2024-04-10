/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Algorithms
import Foundation

extension Grid: Renderable {
    func sizeFor(context: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
//        if case let .false(outerBlock) = environment.allowMultipageBlocks {
//            ErrorMessageBlock(message: errorMessage(innerBlock: "MultipageGrid", outerBlock: outerBlock))
//                .getRenderable(environment: environment)
//                .sizeFor(context: context, environment: environment, proposedSize: proposedSize)
//        } else
        if context.multipageMode {
            BlockSize(width: proposedSize.width, height: 0)
        } else {
            BlockSize(proposedSize)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
//        if case let .false(outerBlock) = environment.allowMultipageBlocks {
//            ErrorMessageBlock(message: errorMessage(innerBlock: "MultipageGrid", outerBlock: outerBlock))
//                .getRenderable(environment: environment)
//                .render(context: context, environment: environment, rect: rect)
//            return
//        }
//        if context.multipageMode == false {
//            context.beginMultipageRendering(environment: environment, rect: rect)
//        }
        let blocks = content.getRenderables(environment: environment)
        let cellWidth = (rect.width - CGFloat(columnCount - 1) * columnSpacing.points) / CGFloat(columnCount)
        let cellSize = CGSize(width: cellWidth, height: .infinity)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposedSize: cellSize) }
        let rows = zip(blocks, sizes).map { $0 }.chunks(ofCount: columnCount)
        for (offset, row) in rows.enumerated() {
            // Add intrarow spacing
            if offset > 0 {
                context.advanceMultipageCursor(rowSpacing.points)
            }
            let rowHeight = row.map(\.1.max.height).reduce(0, max)
            context.renderMultipageContent(rect: rect, height: rowHeight) { rowRect in
                var dx = 0.0
                for (block, size) in row {
                    let cellRect = CGRect(origin: rowRect.origin.offset(dx: dx, dy: 0),
                                          size: .init(width: cellWidth, height: rowHeight))
                    let blockRect = cellRect.rectInCenter(size: size.max)
                    block.render(context: context, environment: environment, rect: blockRect)
                    dx += cellWidth + columnSpacing.points
                }
            }
        }
    }

    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(containsMultipageBlock: true)[keyPath: keypath]
    }
}
