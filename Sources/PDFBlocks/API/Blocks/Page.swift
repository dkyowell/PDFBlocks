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
    ///   - precomputePageCount: Pre-flight run of document  to compute total pages for "Page x of n" style reporting.
    ///   - content: A block builder that creates the content of this page.
    public init(size: PageSize,
                margins: EdgeInsets,
                precomputePageCount: Bool = false,
                @BlockBuilder content: @escaping () -> Content)
    {
        pageInfo = .init(size: size, margins: margins, precomputePageCount: precomputePageCount)
        self.content = content()
    }
}
