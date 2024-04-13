/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func stroke(_ value: Color, lineWidth: Size) -> some Block {
        environment(\.strokeColor, value)
            .environment(\.strokeLineWidth, lineWidth)
    }

    func strokeColor(_ value: Color) -> some Block {
        environment(\.strokeColor, value)
    }

    func strokeLineWidth(_ value: Size) -> some Block {
        environment(\.strokeLineWidth, value)
    }
}

struct StokeColorKey: EnvironmentKey {
    static let defaultValue = Color.black
}

extension EnvironmentValues {
    var strokeColor: Color {
        get { self[StokeColorKey.self] }
        set { self[StokeColorKey.self] = newValue }
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
