/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets text to bold.
    func boldFontName(_ value: FontName) -> some Block {
        environment(\.boldFontName, value)
    }
}

struct BoldFontNameKey: EnvironmentKey {
    static let defaultValue: FontName? = nil
}

extension EnvironmentValues {
    var boldFontName: FontName? {
        get { self[BoldFontNameKey.self] }
        set { self[BoldFontNameKey.self] = newValue }
    }
}
