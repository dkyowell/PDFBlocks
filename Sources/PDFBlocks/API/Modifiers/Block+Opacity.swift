/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets the transparency of this block.
    ///
    /// When applying the `opacity(_:)` modifier to a block that has already had
    /// its opacity transformed, the modifier multiplies the effect of the
    /// underlying opacity transformation.
    ///
    /// - Parameter opacity: A value between 0 (fully transparent) and 1 (fully  opaque).
    /// - Returns: A block that sets the transparency of this block.
    func opacity(_ opacity: CGFloat) -> some Block {
        modifier(OpacityModifier(opacity: opacity))
    }
}
