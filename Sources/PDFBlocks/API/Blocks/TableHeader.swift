/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block for displaying the table column header.
public struct TableHeader: Block {
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
            HDivider()
                .padding(vertical: .in(0.02))
        }
    }
}
