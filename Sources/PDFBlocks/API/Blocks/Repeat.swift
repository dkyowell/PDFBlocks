/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that repeats its contents n times.
///
/// Example:
///
///     VStack {
///         Repeat(count: 20) {
///             Text("ABC")
///         }
///     }
public struct Repeat<Content>: Block where Content: Block {
    let count: Int
    let content: Content

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///   - count: The number of times to repeat the content.
    ///   - content: A block builder that creates the  content.
    public init(count: Int, @BlockBuilder content: () -> Content) {
        self.count = count
        self.content = content()
    }
}
