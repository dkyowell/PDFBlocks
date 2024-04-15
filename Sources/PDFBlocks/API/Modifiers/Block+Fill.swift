/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func fill(_ value: ShapeStyle) -> some Block {
        environment(\.fill, value)
    }
}

struct FillKey: EnvironmentKey {
    static let defaultValue: ShapeStyle? = nil
}

extension EnvironmentValues {
    var fill: ShapeStyle? {
        get { self[FillKey.self] }
        set { self[FillKey.self] = newValue }
    }
}
