/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Adds a background to this block with the specified content and alignment.
    ///
    /// - Parameters:
    ///   - alignment: The alignment of the background content.
    ///   - content: The background content.
    ///
    /// - Returns: A block that adds a background to this block.
    func background(alignment: Alignment = .center, @BlockBuilder _ content: () -> some Block) -> some Block {
        Background(content: self, background: content(), alignment: alignment)
    }
}
