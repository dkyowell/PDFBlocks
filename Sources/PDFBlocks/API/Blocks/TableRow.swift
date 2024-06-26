/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block for printing a row within a `Table`.
public struct TableRow<Value>: Block {
    private let record: Value
    @Environment(\.tableColumns) private var columns

    /// Creates an instance.
    /// - Parameters:
    ///   - record: The table record to be displayed.
    public init(record: Value) {
        self.record = record
    }

    public var body: some Block {
        HStack(alignment: .top, spacing: .pt(2)) {
            ForEach(columns.filter(\.visible).compactMap { $0 as? any TableColumnContent<Value> }) { column in
                AnyBlock(column.cellContent(record: record))
                    .proportionalFrame(width: column.width, alignment: column.alignment)
            }
        }
    }
}
