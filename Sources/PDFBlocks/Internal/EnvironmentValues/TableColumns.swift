/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// A Table's columns are stored in the environment. They are read from the environment by TableColumnTitles and
// TableRow.
private struct TableColumnsKey: EnvironmentKey {
    static let defaultValue: [any TableColumnContent] = []
}

extension EnvironmentValues {
    var tableColumns: [any TableColumnContent] {
        get { self[TableColumnsKey.self] }
        set { self[TableColumnsKey.self] = newValue }
    }
}
