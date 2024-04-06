/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block for displaying a table row within a Table.
public struct TableRow<Value>: Block {
    private let record: Value
    @Environment(\.tableColumns) private var columns

    public init(record: Value) {
        self.record = record
    }

    public var body: some Block {
        HStack(spacing: .pt(2)) {
            ForEach(data: columns.filter(\.visible).compactMap { $0 as? any TableColumnContent<Value> }) { column in
                AnyBlock(column.cellContent(record: record))
                    .proportionalFrame(width: column.width, alignment: column.alignment)
            }
        }
    }
}
