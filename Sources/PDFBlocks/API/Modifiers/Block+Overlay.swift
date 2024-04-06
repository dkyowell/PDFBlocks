/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Adds a overlay to this block with the specified content and alignment.
    ///
    /// - Parameters:
    ///   - alignment: The alignment of the background content.
    ///   - content: The overlay content.
    ///
    /// - Returns: A block that adds an overlay to this block.
    func overlay(alignment: Alignment = .center, @BlockBuilder _ content: () -> some Block) -> some Block {
        modifier(OverlayModifier(overlay: content(), alignment: alignment))
    }
}
