/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

import Foundation

/// Color is both a representation for color generally and a block for rendering
/// a rectangular region of color.
///
/// To set the foregroundColor for a block:
///
///     Text("Hello, world.")
///         .foregroundColor(Color.red)
///
/// To draw a blue square:
///
///     Color(UIColor.blue)
///         .frame(width: .in(1), height: .in(1))
///
/// Each platform (iOS/macOS/Linux) uses its own color type that conforms
/// to PlatformColor.
public struct Color {
    let platformColor: any PlatformColor
}
