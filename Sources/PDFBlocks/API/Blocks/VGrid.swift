/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A container block that arranges its child blocks in a grid that
/// grows vertically.
///
/// A `VGrid` will fill the width of its container with equal width cells.
public struct VGrid<Content>: Block where Content: Block {
    let columnCount: Int
    let columnSpacing: Dimension
    let rowSpacing: Dimension
    let pageWrap: Bool
    let content: Content

    /// Creates a grid that grows vertically.
    ///
    /// - Parameters:
    ///   - columnCount: The number of columns within the grid.
    ///   - columnSpacing: The horizontal distance between cells.
    ///   - rowSpacing: The vertical distance between cells.
    ///   - pageWrap: Start a new page when the content overflows its space.
    ///   - content: A block builder that creates the content of this stack.
    public init(columnCount: Int, columnSpacing: Dimension, rowSpacing: Dimension, pageWrap: Bool = false, @BlockBuilder content: () -> Content) {
        self.columnCount = max(1, columnCount)
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
        self.pageWrap = pageWrap
        self.content = content()
    }
}
