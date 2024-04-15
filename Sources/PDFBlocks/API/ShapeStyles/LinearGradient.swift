/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct RadialGradient: ShapeStyle {
    let gradient: Gradient
    let center: UnitPoint
    let startRadius: Size
    let endRadius: Size

    /// Creates a radial gradient from a base gradient.
    public init(gradient: Gradient, center: UnitPoint, startRadius: Size, endRadius: Size) {
        self.gradient = gradient
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }

    /// Creates a radial gradient from a collection of colors.
    public init(colors: [Color], center: UnitPoint, startRadius: Size, endRadius: Size) {
        gradient = Gradient(colors: colors)
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }

    /// Creates a radial gradient from a collection of color stops.
    public init(stops: [Gradient.Stop], center: UnitPoint, startRadius: Size, endRadius: Size) {
        gradient = Gradient(stops: stops)
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }
}
