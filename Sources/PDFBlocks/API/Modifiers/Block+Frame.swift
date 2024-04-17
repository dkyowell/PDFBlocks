/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Positions this block within an invisible frame with the specified size and
    /// content alignment.
    ///
    /// - Parameters:
    ///   - width: A fixed width for the resulting block. If `width` is `nil`,
    ///     the resulting block assumes this block's sizing behavior.
    ///   - height: A fixed height for the resulting block. If `height` is `nil`,
    ///     the resulting block assumes this block's sizing behavior.
    ///   - alignment: The alignment of this block inside the resulting frame.
    ///
    /// - Returns: A block with fixed dimensions of `width` and `height`, for the
    ///   parameters that are non-`nil`.
    func frame(width: Dimmension? = nil, height: Dimmension? = nil, alignment: Alignment = .topLeading) -> some Block {
        modifier(FrameModifier(width: width, height: height, alignment: alignment))
    }
}
