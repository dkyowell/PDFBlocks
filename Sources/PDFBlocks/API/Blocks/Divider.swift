/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A line .
///
/// When contained in a stack, the divider extends across the minor axis of the stack,
/// or horizontally when not in a stack.
public struct Divider: Block {
    let size: Size
    let padding: Size

    public init(size: Size = .pt(1), padding: Size = .pt(1)) {
        self.size = size
        self.padding = padding
    }
}
