/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets the foreground color for a block.
    func foregroundColor(_ value: Color) -> some Block {
        environment(\.foregroundColor, value)
    }
}

struct ForegroundColorKey: EnvironmentKey {
    static let defaultValue = Color.black
}

extension EnvironmentValues {
    var foregroundColor: Color {
        get { self[ForegroundColorKey.self] }
        set { self[ForegroundColorKey.self] = newValue }
    }
}
