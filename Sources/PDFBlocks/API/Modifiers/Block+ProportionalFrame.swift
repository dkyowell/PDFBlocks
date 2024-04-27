/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets the proportional width of a block within an `HStack`.
    ///
    /// The width parameter is a proportion of the sum of all the
    /// proportional widths. In the following example, the green block
    /// takes twice the width of the other blocks. The red block takes
    /// 25% of the width (1/4), the green block takes 50% of the width
    /// (2/4), and the blue block takes 25% of the width (1/4).
    ///
    ///     HStack() {
    ///         Color.red
    ///             .proportionalFrame(width: 1)
    ///         Color.green
    ///             .proportionalFrame(width: 2)
    ///         Color.blue
    ///             .proportionalFrame(width: 1)
    ///     }
    ///
    /// In this example, the red block takes 35% of the width,
    /// the green block takes 20%, and the blue
    /// block takes 55%.
    ///
    ///     HStack() {
    ///         Color.red
    ///             .proportionalFrame(width: 35)
    ///         Color.green
    ///             .proportionalFrame(width: 20)
    ///         Color.blue
    ///             .proportionalFrame(width: 55)
    ///     }
    ///
    /// - Parameter width: The proportional width to apply.
    /// - Parameter alignment: The horizontal alignment of the block within its frame.
    /// - Returns: A block that sets the proportional width of this block.
    func proportionalFrame(width: CGFloat = 1, alignment: HorizontalAlignment = .center) -> some Block {
        ProporionalFrame(width: width, horizontalAlignment: alignment, content: self)
    }
}
