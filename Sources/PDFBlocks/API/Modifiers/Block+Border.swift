/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Adds a border to this block with the specified color and width.
    ///
    /// The border will be centered on the perimeter of the block.
    ///
    /// The width of the border does not change the size of the block. If
    /// that behavior is desired, the border modifier should be followed
    /// with a padding modifier.
    ///
    /// - Parameters:
    ///   - color: The color of the border.
    ///   - width: The thickness of the border.
    ///
    /// - Returns: A block that adds a border with the specified style and width
    ///   to this block.
    func border(_ content: ShapeStyle, width: Size = .pt(1)) -> some Block {
        modifier(BorderModifier(shapeStyle: content, width: width))
    }
}
