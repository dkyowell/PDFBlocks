/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct RadialGradient: ShapeStyle {
    let gradient: Gradient
    let center: UnitPoint
    let startRadius: Dimension
    let endRadius: Dimension

    /// Creates a radial gradient from a base gradient.
    public init(gradient: Gradient, center: UnitPoint, startRadius: Dimension, endRadius: Dimension) {
        self.gradient = gradient
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }

    /// Creates a radial gradient from a collection of colors.
    public init(colors: [Color], center: UnitPoint, startRadius: Dimension, endRadius: Dimension) {
        gradient = Gradient(colors: colors)
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }

    /// Creates a radial gradient from a collection of color stops.
    public init(stops: [Gradient.Stop], center: UnitPoint, startRadius: Dimension, endRadius: Dimension) {
        gradient = Gradient(stops: stops)
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }
}
