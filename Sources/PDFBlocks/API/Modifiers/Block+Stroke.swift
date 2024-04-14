/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func stroke(_ content: ShapeStyle, lineWidth: Size = .pt(1)) -> some Block {
        environment(\.strokeContent, content)
            .environment(\.strokeLineWidth, lineWidth)
    }
}

struct StokeContentKey: EnvironmentKey {
    static let defaultValue: ShapeStyle = Color.black
}

extension EnvironmentValues {
    var strokeContent: ShapeStyle {
        get { self[StokeContentKey.self] }
        set { self[StokeContentKey.self] = newValue }
    }
}

struct StrokeLineWidthKey: EnvironmentKey {
    static let defaultValue = Size.pt(0)
}

extension EnvironmentValues {
    var strokeLineWidth: Size {
        get { self[StrokeLineWidthKey.self] }
        set { self[StrokeLineWidthKey.self] = newValue }
    }
}
