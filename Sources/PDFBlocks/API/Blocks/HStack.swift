/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A container block that arranges its contents in a horizontal line.
///
/// This example shows a simple horizontal stack of three text blocks:
///
///     var body: some Block {
///         HStack(spacing: .pt(12) {
///             Text("Quick")
///             Text("Brown")
///             Text("Fox")
///         }
///     }
public struct HStack<Content: Block>: Block {
    let alignment: VerticalAlignment
    let spacing: StackSpacing
    let content: Content
    let cacheId = UUID()

    /// Creates a horizontal stack with the given spacing and vertical alignment.
    ///
    /// - Parameters:
    ///   - alignment: The vertical alignment for the contents of the stack.
    ///   - spacing: The distance between  elements of the stack.
    ///   - content: A block builder that creates the content of this stack.
    public init(alignment: VerticalAlignment = .center, spacing: StackSpacing = .none, @BlockBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
}
