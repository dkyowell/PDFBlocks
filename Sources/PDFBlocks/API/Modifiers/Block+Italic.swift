/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets italic value of block.
    func italic(_ value: Bool = true) -> some Block {
        environment(\.italic, value)
    }
}

struct ItalicKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var italic: Bool {
        get { self[ItalicKey.self] }
        set { self[ItalicKey.self] = newValue }
    }
}
