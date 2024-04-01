/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets the font name for a block.
    func font(name: FontName) -> some Block {
        environment(\.fontName, name)
    }

    /// Sets the font size for a block.
    func font(size: CGFloat) -> some Block {
        environment(\.fontSize, size)
    }

    /// Sets the font name and size for a block.
    func font(name: FontName, size: CGFloat) -> some Block {
        environment(\.fontName, name)
            .environment(\.fontSize, size)
    }
}

struct FontNameKey: EnvironmentKey {
    static let defaultValue: FontName = "Helvetica"
}

extension EnvironmentValues {
    var fontName: FontName {
        get { self[FontNameKey.self] }
        set { self[FontNameKey.self] = newValue }
    }
}

struct FontSizeKey: EnvironmentKey {
    static let defaultValue: CGFloat = 9
}

extension EnvironmentValues {
    var fontSize: CGFloat {
        get { self[FontSizeKey.self] }
        set { self[FontSizeKey.self] = newValue }
    }
}
