/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func fill(_ value: ShapeStyle) -> some Block {
        if let value = value as? Gradient {
            let linearGradient = LinearGradient(gradient: value, startPoint: .top, endPoint: .bottom)
            return environment(\.fill, linearGradient)
        } else {
            return environment(\.fill, value)
        }
    }
}

struct FillKey: EnvironmentKey {
    static let defaultValue: ShapeStyle = Color.black
}

extension EnvironmentValues {
    var fill: ShapeStyle {
        get { self[FillKey.self] }
        set { self[FillKey.self] = newValue }
    }
}
