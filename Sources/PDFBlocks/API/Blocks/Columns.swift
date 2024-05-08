/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that arranges its contents into columns.
///
/// ELEMENTS WITHIN `Columns` THAT ARE VERTICALLY UNCONSTRAINED
/// WILL NOT BE RENDERED. THIS INCLUDES SHAPES AND IMAGES WITHOUT
/// A FRAME(HEIGHT:) DESIGNATION AND MAX VERTICALY PADDED ELEMENTS.
///
/// Columns works like a multi-column VStack. When the content reaches
/// the bottom of one column, it starts again at the start of the next.
public struct Columns<Content>: Block where Content: Block {
    let count: Int
    let spacing: Dimension
    let pageWrap: Bool
    let content: Content

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///   - count: The number of columns.
    ///   - spacing: The horizontal spacing between columns.
    ///   - pageWrap: Start a new page when the content overflows its space.
    ///   - content: A block builder that creates the Columns content.
    public init(count: Int, spacing: Dimension, pageWrap: Bool = false, @BlockBuilder content: () -> Content) {
        self.count = max(1, count)
        self.spacing = spacing
        self.pageWrap = pageWrap
        self.content = content()
    }
}
