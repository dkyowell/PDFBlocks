/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct LinearGradient: ShapeStyle {
    let gradient: Gradient
    let startPoint: UnitPoint
    let endPoint: UnitPoint

    /// Creates a linear gradient from a base gradient.
    public init(gradient: Gradient, startPoint: UnitPoint, endPoint: UnitPoint) {
        self.gradient = gradient
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    /// Creates a linear gradient from a collection of colors.
    public init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) {
        gradient = .init(colors: colors)
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    /// Creates a linear gradient from a collection of color stops.
    public init(stops: [Gradient.Stop], startPoint: UnitPoint, endPoint: UnitPoint) {
        gradient = .init(stops: stops)
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
