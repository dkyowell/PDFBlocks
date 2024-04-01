/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension ColumnStack: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        var environment = environment
        environment.allowMultipageBlocks = .false("ColumnStack")
        let blocks = content.getRenderables(environment: environment)
        let columnWidthSum = columns.map(\.width).reduce(0, +)
        let blockSizes = zip(blocks, columns).map { block, column in
            let proportion = column.width / columnWidthSum
            let proposedBlockSize = ProposedSize(width: proposedSize.width * proportion, height: proposedSize.height)
            return block.sizeFor(context: context, environment: environment, proposedSize: proposedBlockSize)
        }
        let maxHeight = blockSizes.map(\.max.height).reduce(0, max)
        return .init(min: .init(width: proposedSize.width, height: maxHeight),
                     max: .init(width: proposedSize.width, height: maxHeight))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.allowMultipageBlocks = .false("ColumnStack")
        let blocks = content.getRenderables(environment: environment)
        var blockOffset = 0.0
        let columnWidthSum = columns.map(\.width).reduce(0, +)
        for (block, column) in zip(blocks, columns) {
            let blockWidth = rect.width * column.width / columnWidthSum
            let blockSize = block.sizeFor(context: context, environment: environment, proposedSize: .init(width: blockWidth, height: rect.height))
            let dx: CGFloat = switch column.alignment {
            case .leading:
                0
            case .center:
                (blockWidth - blockSize.max.width) / 2
            case .trailing:
                blockWidth - blockSize.max.width
            }
            let blockRect = CGRect(origin: rect.origin.offset(dx: blockOffset + dx, dy: 0), size: blockSize.max)
            block.render(context: context, environment: environment, rect: blockRect)
            blockOffset += blockWidth
        }
    }
}
