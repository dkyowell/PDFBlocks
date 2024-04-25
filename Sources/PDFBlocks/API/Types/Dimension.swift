/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type for expressing width and height dimmensions or spacing.
///
/// `Dimmension` can be expressed in points (72 ppi), inches, milimeters.
///
/// The following paddings values are all equivalent.
///
///     Text("Hello, world.")
///         .padding(.mm(25.4))
///     Text("Hello, world.")
///         .padding(.in(1))
///     Text("Hello, world.")
///         .padding(.pt(72))
///
///
/// `Dimmension` can also be given a pseudo-value of `max` that indicates the maximum
/// availible width, height, or spacing.
///
///     Text("Hello, world.")
///         .padding(horizontal: .max)
///
public struct Dimension: Equatable {
    public let points: CGFloat
    public let max: Bool

    public static var max: Dimension {
        .init(points: 0, max: true)
    }

    public static func pt(_ value: CGFloat) -> Dimension {
        .init(points: value, max: false)
    }

    public static func `in`(_ value: CGFloat) -> Dimension {
        .init(points: value * 72, max: false)
    }

    public static func mm(_ value: CGFloat) -> Dimension {
        .init(points: value * 72 / 25.4, max: false)
    }
}

extension Dimension: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        points = CGFloat(value)
        max = false
    }
}

extension Dimension: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        points = value
        max = false
    }
}
