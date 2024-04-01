/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that arranges its contents horizontally as specified by its columns.
public struct ColumnStack<Content>: Block where Content: Block {
    let columns: [StackColumn]
    let content: Content

    public init(columns: [StackColumn], @BlockBuilder content: () -> Content) {
        self.columns = columns
        self.content = content()
    }
}

/// A description of a column in a `ColumnStack`.
public struct StackColumn {
    /// The proportional width of the column.
    ///
    /// A `ColumnStack` will always take up the full width of its container.
    /// The width of each column is specified as a proportion of the sum of
    /// all the column widths.
    public let width: CGFloat
    /// The alignment to use for the content of the column.
    public let alignment: HorizontalAlignment
}
