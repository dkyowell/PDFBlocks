/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets text to bold.
    func emphasizedFontName(_ value: FontName) -> some Block {
        environment(\.emphasizedFontName, value)
    }
}

struct EmphasizedFontNameKey: EnvironmentKey {
    static let defaultValue: FontName? = nil
}

extension EnvironmentValues {
    var emphasizedFontName: FontName? {
        get { self[EmphasizedFontNameKey.self] }
        set { self[EmphasizedFontNameKey.self] = newValue }
    }
}
