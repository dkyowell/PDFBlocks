/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func tag(_ value: String) -> some Block {
        environment(\.tag, value)
    }
}

// Used for debugging.
struct TagKey: EnvironmentKey {
    static let defaultValue = ""
}

extension EnvironmentValues {
    var tag: String {
        get { self[TagKey.self] }
        set { self[TagKey.self] = newValue }
    }
}
