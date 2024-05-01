/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type-erased block.
///
/// An AnyBlock can allow you to use data driven
/// content in your documents. Consider the following example
/// in which a Response can be displayed as one of three
/// types of  Blocks (Image, RotationEffect, or Text). 'any Block'
/// cannot be used within a BlockBuilder, but AnyBlock can.
///
///     enum Response {
///         case likes
///         case dislikes
///         case custom(String)
///
///         var block: any Block {
///             switch self {
///                 case .likes:
///                     Image(.init(systemName: "hand.thumbsup")!)
///                 case .dislikes:
///                     Image(.init(systemName: "hand.thumbsup")!)
///                         .rotationEffect(.degrees(180))
///                 case .custom(let string):
///                     Text(string)
///         }
///     }
///
///     struct Document: Block {
///         let responses: [Response]
///
///         var body: some Block {
///             ForEach(responses) { response in
///                 AnyBlock(response.block)
///             }
///         }
///     }
///
public struct AnyBlock: Block {
    let content: any Block

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///   - content: The block to be erased.
    public init(_ content: some Block) {
        self.content = content
    }
}
