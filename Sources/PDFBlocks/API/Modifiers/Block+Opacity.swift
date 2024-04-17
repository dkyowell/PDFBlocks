/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets the opacity of elements within this block.
    ///
    /// - Parameter opacity: The opacity value to apply.
    /// - Returns: A block for which the given opacity has been set.
    func opacity(_ opacity: CGFloat) -> some Block {
        modifier(OpacityModifier(opacity: opacity))
    }
}
