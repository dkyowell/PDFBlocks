/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that arranges its contents into columns.
///
/// Columns works like a multi-column VStack. When the content reaches
/// the bottom of one column, it starts again at the start of the next.
public struct Columns<Content>: Block where Content: Block {
    let count: Int
    let spacing: Dimension
    let allowWrap: Bool
    let content: Content

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///   - count: The number of columns.
    ///   - spacing: The horizontal spacing between columns.
    ///   - allowWrap: Start a new page when content overflows space.
    ///   - content: A block builder that creates the Columns content.
    public init(count: Int, spacing: Dimension, allowWrap: Bool = false, @BlockBuilder content: () -> Content) {
        self.count = max(1, count)
        self.spacing = spacing
        self.allowWrap = allowWrap
        self.content = content()
    }
}
