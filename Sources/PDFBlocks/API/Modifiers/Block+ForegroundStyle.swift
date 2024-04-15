/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets the foreground color for a block.
    func foregroundStyle(_ value: ShapeStyle) -> some Block {
        environment(\.foregroundStyle, value)
    }
}

struct ForegroundStyleKey: EnvironmentKey {
    static let defaultValue: ShapeStyle = Color.black
}

extension EnvironmentValues {
    var foregroundStyle: ShapeStyle {
        get { self[ForegroundStyleKey.self] }
        set { self[ForegroundStyleKey.self] = newValue }
    }
}
