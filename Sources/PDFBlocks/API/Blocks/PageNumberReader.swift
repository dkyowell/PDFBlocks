/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A container block that dynamically creates its content,
/// providing the current page number as an input parameter
/// to the block builder function.
///
/// Providing the total page count through the `PageNumberProxy`
/// is an expensive operation. Essentially, the entire document must
/// be rendered twice. Therefore, this option is not enabled by default;
/// It must be enabled by setting the `precomputePageCount:`
/// parameter for `Page` to true.
public struct PageNumberReader<Content>: Block where Content: Block {
    let content: (PageNumberProxy) -> Content

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///   - content: A block builder that creates a block dynamically.
    public init(@BlockBuilder content: @escaping (PageNumberProxy) -> Content) {
        self.content = content
    }
}
