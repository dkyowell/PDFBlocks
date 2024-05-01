/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// TODO: DOCS
/// A block that prints the table column titles.
///
/// This block is used to render the column titles of a table. It will usually
/// be used within a table header, a group header, or a page header:
///
///     Table(data: [data]) {
///         TableColumn("Col 1", \.col1, 33)
///         TableColumn("Col 2", \.col2, 33)
///         TableColumn("Col 3", \.col3, 33)
///     } groups {
///         TableGroup(on: \.col1) { rows, value in
///             Text("Group header for \(value)")
///             TableColumnTitles()
///         } footer: { rows, value in
///         }
///     }
public struct TableColumnTitles: Block {
    @Environment(\.tableColumns) private var columns

    /// Creates an instance.
    public init() {}

    public var body: some Block {
        VStack {
            HStack(alignment: .top, spacing: .pt(2)) {
                ForEach(columns.filter(\.visible)) { column in
                    Text(column.title)
                        .fontWeight(.medium)
                        .proportionalFrame(width: column.width, alignment: column.alignment)
                }
            }
            Divider()
        }
    }
}
