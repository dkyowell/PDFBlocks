/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Constrains a block to a specified aspect ratio.
    ///
    /// In this example, the second color block will be only as tall as
    /// it is wide.
    ///
    ///     HStack {
    ///         Color(.systemRed)
    ///         Color(.systemGreen)
    ///             .aspectRatio(1)
    ///         Color(.systemBlue)
    ///     }
    ///
    /// - Parameter value: The aspect ratio (width/height) to apply.
    /// - Returns: A block that applies an aspect ratio to this block.
    func aspectRatio(_ value: CGFloat, contentMode _: ContentMode = .fit) -> some Block {
        modifier(AspectRatioModifier(value: value))
    }
}
