/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets emphasized value of block.
    func bold(_ value: Bool = true) -> some Block {
        environment(\.bold, value)
    }
}

struct BoldKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var bold: Bool {
        get { self[BoldKey.self] }
        set { self[BoldKey.self] = newValue }
    }
}
