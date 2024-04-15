/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A color or pattern to use when rendering a shape.
public protocol ShapeStyle {}

extension ShapeStyle where Self == Color {
    static var clear: Color {
        Color.clear
    }

    static var blue: Color {
        Color.blue
    }

    static var red: Color {
        Color.red
    }

    static var green: Color {
        Color.green
    }

    static var yellow: Color {
        Color.yellow
    }

    static var orange: Color {
        Color.orange
    }

    static var purple: Color {
        Color.purple
    }

    static var pink: Color {
        Color.pink
    }

    static var cyan: Color {
        Color.cyan
    }

    static var gray: Color {
        Color.gray
    }

    static var white: Color {
        Color.white
    }

    static var black: Color {
        Color.black
    }
}
