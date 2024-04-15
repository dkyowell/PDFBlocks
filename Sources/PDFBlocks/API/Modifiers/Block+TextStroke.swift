/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func textFill(_ color: Color) -> some Block {
        environment(\.textFill, color)
    }
}

struct TextFillKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

extension EnvironmentValues {
    var textFill: Color? {
        get { self[TextFillKey.self] }
        set { self[TextFillKey.self] = newValue }
    }
}
