/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that arranges its contents with one element overlaid on
/// top of another.
///
/// This example shows a simple z stack of three color blocks:
///
///     var body: some Block {
///         ZStack(alignment: .center) {
///             Color.red
///                 .frame(width: 3, height: 3)
///             Color.blue
///                 .frame(width: 2, height: 2)
///             Color.green
///                 .frame(width: 1, height: 1)
///         }
///     }
public struct ZStack<Content: Block>: Block {
    let alignment: Alignment
    let content: Content

    /// Creates a z stack with the given  alignment.
    ///
    /// - Parameters:
    ///   - alignment: The horizontal and vertical alignment for the contents of the stack.
    ///   - content: A block builder that creates the content of this stack.
    public init(alignment: Alignment = .topLeading, @BlockBuilder content: () -> Content) {
        self.alignment = alignment
        self.content = content()
    }
}
