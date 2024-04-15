/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct Gradient {
    public struct Stop {
        /// The color for the stop.
        public var color: Color

        /// The parametric location of the stop.
        ///
        /// This value must be in the range `[0, 1]`.
        public var location: CGFloat

        /// Creates a color stop with a color and location.
        public init(color: Color, location: CGFloat) {
            self.color = color
            self.location = location
        }
    }

    public var stops: [Gradient.Stop]

    public init(colors: [Color]) {
        let denominator = max(1, colors.count - 1)
        stops = colors.enumerated()
            .map { Stop(color: $0.element, location: Double($0.offset) / Double(denominator)) }
    }

    public init(stops: [Gradient.Stop]) {
        self.stops = stops
    }
}
