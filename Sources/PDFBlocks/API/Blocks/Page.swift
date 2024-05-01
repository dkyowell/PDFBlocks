/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that defines an entire PDF page.
///
/// A page should be the outermost container within a document,
/// although most modifiers can be applied to `Page`.
public struct Page<Content>: Block where Content: Block {
    let pageInfo: PageInfo
    let content: Content

    /// Creates an instance with the given parameters.
    ///
    /// - Parameters:
    ///   - size: The size of the page.
    ///   - margins: The margins of the page.
    ///   - content: A block builder that creates the content of this page.
    public init(size: PageSize, margins: EdgeInsets, @BlockBuilder content: @escaping () -> Content) {
        pageInfo = .init(size: size, margins: margins)
        self.content = content()
    }
}
