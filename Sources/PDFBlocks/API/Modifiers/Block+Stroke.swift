/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func stroke(_ content: some ShapeStyle, lineWidth: Dimension = .pt(1)) -> some Block {
        environment(\.strokeContent, content)
            .environment(\.strokeStyle, StrokeStyle(lineWidth: lineWidth))
    }

    func stroke(_ content: some ShapeStyle, style: StrokeStyle) -> some Block {
        environment(\.strokeContent, content)
            .environment(\.strokeStyle, style)
    }
}

struct StokeContentKey: EnvironmentKey {
    static let defaultValue: ShapeStyle? = nil
}

extension EnvironmentValues {
    var strokeContent: ShapeStyle? {
        get { self[StokeContentKey.self] }
        set { self[StokeContentKey.self] = newValue }
    }
}

struct StrokeStyleKey: EnvironmentKey {
    static let defaultValue = StrokeStyle()
}

extension EnvironmentValues {
    var strokeStyle: StrokeStyle {
        get { self[StrokeStyleKey.self] }
        set { self[StrokeStyleKey.self] = newValue }
    }
}
