/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type for expressing width and height dimmensions or spacing.
///
/// `Size` can be expressed in points (72 ppi), inches, milimeters.
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
/// `Size` can also be given a pseudo-value of `max` that indicates the maximum
/// availible width, height, or spacing.
///
///     Text("Hello, world.")
///         .padding(horizontal: .max)
///
public struct Size: Equatable {
    public let points: CGFloat
    public let max: Bool

    public static var max: Size {
        .init(points: 0, max: true)
    }

    public static func pt(_ value: CGFloat) -> Size {
        .init(points: value, max: false)
    }

    public static func `in`(_ value: CGFloat) -> Size {
        .init(points: value * 72, max: false)
    }

    public static func mm(_ value: CGFloat) -> Size {
        .init(points: value * 72 / 25.4, max: false)
    }
}
