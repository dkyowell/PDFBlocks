/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that computes blocks on demand from an underlying array of data.
///
/// Example:
///
///     VStack {
///         ForEach(["Quick", "Brown", "Fox"]) { item in
///             Text(item)
///         }
///     }
public struct ForEach<T, Content>: Block where Content: Block {
    let content: (T) -> Content
    let data: [T]

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///   - data: The data used to create blocks dynamically.
    ///   - content: The block builder that creates blocks dynamically.
    public init(_ data: [T], @BlockBuilder content: @escaping (T) -> Content) {
        self.data = data
        self.content = content
    }
}
