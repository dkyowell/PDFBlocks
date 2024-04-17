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
    let thickness: Dimmension
    let padding: Dimmension

    public init(thickness: Dimmension = .pt(0.75), padding: Dimmension = .pt(1)) {
        self.thickness = thickness
        self.padding = padding
    }
}
