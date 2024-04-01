/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Adds an action to perform after this block is rendered.
    ///
    /// - Parameter action: The action to perform.
    ///
    /// - Returns: A block that triggers `action` after it is rendered.
    func onRender(perform action: @escaping () -> Void) -> some Block {
        modifier(OnRenderModifier(onRender: action))
    }
}
