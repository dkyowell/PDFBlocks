/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that arranges its contents in a vertical line.
///
/// This example shows a simple vertical stack of three text blocks:
///
///     var body: some Block {
///         VStack(spacing: .pt(12) {
///             Text("Quick")
///             Text("Brown")
///             Text("Fox")
///         }
///     }
public struct VStack<Content>: Block where Content: Block {
    let alignment: HorizontalAlignment
    let spacing: StackSpacing
    let allowWrap: Bool
    let content: Content

    /// Creates a vertical stack with the given spacing and vertical alignment.
    ///
    /// - Parameters:
    ///   - alignment: The horizontal alignment for the contents of the stack.
    ///   - spacing: The distance between  elements of the stack.
    ///   - content: A block builder that creates the content of this stack.
    public init(alignment: HorizontalAlignment = .center,
                spacing: StackSpacing = .none,
                allowWrap: Bool = false,
                @BlockBuilder content: () -> Content)
    {
        self.alignment = alignment
        self.spacing = spacing
        self.allowWrap = allowWrap
        self.content = content()
    }
}
