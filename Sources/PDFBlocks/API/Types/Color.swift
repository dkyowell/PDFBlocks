/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A representation of a color that adapts to a given context.
///
/// Color conforms to Block, so is displayed as a rectangular
/// block of color.
public struct Color {
    public init(_ color: any PlatformColor) {
        representation = color
    }

    let representation: any PlatformColor
}
