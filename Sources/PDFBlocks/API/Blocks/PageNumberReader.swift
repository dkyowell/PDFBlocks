/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A container block that dynamically creates its content,
/// providing the current page number as an input parameter
/// to the block builder function.
public struct PageNumberReader<Content>: Block where Content: Block {
    let content: (Int) -> Content

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///   - content: A block builder that creates a block dynamically.
    public init(@BlockBuilder content: @escaping (Int) -> Content) {
        self.content = content
    }
}
