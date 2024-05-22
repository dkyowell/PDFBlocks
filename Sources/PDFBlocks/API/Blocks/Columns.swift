/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that arranges its contents into equal length columns.
///
/// NOTE: Elements within `Columns` with unconstrained heights
/// can give unexpected results with respect to balanced column heights.
public struct Columns<Content>: Block where Content: Block {
    let count: Int
    let spacing: Dimension
    let wrap: Bool
    let content: Content

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///   - count: The number of columns.
    ///   - spacing: The horizontal spacing between columns.
    ///   - wrapping: Start a new page or column when the content overflows its space.
    ///   - content: A block builder that creates the Columns content.
    public init(count: Int, spacing: Dimension, wrap: Bool = false, @BlockBuilder content: () -> Content) {
        self.count = max(1, count)
        self.spacing = spacing
        self.wrap = wrap
        self.content = content()
    }
}
