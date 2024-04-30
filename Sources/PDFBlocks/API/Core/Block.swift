/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type that represents part of a PDF document.
///
/// You create custom blocks by declaring types that conform to the `Block`
/// protocol. Implement the required ``Block/body-swift.property`` computed
/// property to provide the content for your custom block.
///
///     struct MyBlock: Block {
///         var body: some Block {
///             Text("Hello, World!")
///         }
///     }
///
/// Assemble the block's body by combining one or more of the built-in blocks
/// provided by PDF Blocks, like the ``Text`` instance in the example above, plus
/// other custom blocks that you define, into a hierarchy of blocks.
///
/// The `Block` protocol provides a set of modifiers — protocol
/// methods with default implementations — that you use to configure
/// blocks in the layout of your app. Modifiers work by wrapping the
/// block instance on which you call them in another block with the specified
/// characteristics. For example, adding the ``Block/opacity(_:)`` modifier to a
/// text block returns a new block with some amount of transparency:
///
///     Text("Hello, World!")
///         .opacity(0.5) // Display partially transparent text.
///

public protocol Block {
    /// The type of block representing the body of this view.
    ///
    /// When you create a custom block, Swift infers this type from your
    /// implementation of the required body property.
    associatedtype Body: Block
    /// The content and behavior of the block.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your block. Return a block
    /// that's composed of built-in blocks that PDFBlocks provides, plus other
    /// composite blocks that you've already defined:
    ///
    ///     struct MyBlock: Block {
    ///         var body: some Block {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    @BlockBuilder var body: Body { get }
}

public extension Block {
    func renderPDF(size: PageSize = .letter, margins: EdgeInsets = .in(1)) async throws -> Data? {
        try await Context().render(size: size, margins: margins, content: self)
    }
}
