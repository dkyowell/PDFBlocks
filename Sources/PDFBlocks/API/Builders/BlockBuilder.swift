/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A custom parameter attribute that constructs blocks from closures.
@resultBuilder
public struct BlockBuilder {
    /// Produces an empty block from a block containing no statements.
    public static func buildBlock() -> EmptyBlock {
        EmptyBlock()
    }

    /// Passes a single block written as a child block through unmodified.
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: Block {
        content
    }

    /// Produces a tuple block for multi block content.
    public static func buildBlock<each Content>(_ content: repeat each Content) -> TupleBlock < (repeat each Content)> where repeat each Content: Block {
        TupleBlock((repeat each content))
    }

    /// Produces an optional block for conditional statements in multi-statement
    /// closures that's only visible when the condition evaluates to true.
    public static func buildOptional<Content>(_ content: Content?) -> Content? where Content: Block {
        // Note: this requires a conformance of Optional to Block
        content
    }

    /// Produces content for a conditional statement in a multi-statement closure
    /// when the condition is true.
    public static func buildEither<T, F>(first: T) -> EitherBlock<T, F> where T: Block, F: Block {
        EitherBlock(value: .trueContent(first))
    }

    /// Produces content for a conditional statement in a multi-statement closure
    /// when the condition is false.
    public static func buildEither<T, F>(second: F) -> EitherBlock<T, F> where T: Block, F: Block {
        EitherBlock(value: .falseContent(second))
    }
}
