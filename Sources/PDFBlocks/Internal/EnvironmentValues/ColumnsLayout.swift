/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct ColumnsLayoutKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var columnsLayout: Bool {
        get { self[ColumnsLayoutKey.self] }
        set { self[ColumnsLayoutKey.self] = newValue }
    }
}
