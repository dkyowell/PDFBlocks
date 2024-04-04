/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block for displaying the table column titles.
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

    public var body: some Block {
        VStack {
            let stackColumns = columns.filter(\.visible).map { StackColumn(width: $0.width, alignment: $0.alignment) }
            ColumnStack(columns: stackColumns) {
                ForEach(data: columns.filter(\.visible)) { column in
                    Text(column.title)
                        .emphasized()
                }
            }
            Divider()
                .padding(vertical: .pt(1.5))
        }
    }
}
