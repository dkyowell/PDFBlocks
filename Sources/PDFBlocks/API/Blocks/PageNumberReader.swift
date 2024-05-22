/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A container block that dynamically creates its content,
/// providing the current page number and total page count
/// as an input parameter to the block builder function.
///
public struct PageNumberReader<Content>: Block where Content: Block {
    let computePageCount: Bool
    let content: (PageNumberProxy) -> Content

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///
    ///   - computePageCount: PageNumberReader will return the total page count at the expense of pdf generation speed.
    ///   - content: A block builder that creates a block dynamically.
    public init(computePageCount: Bool, @BlockBuilder content: @escaping (PageNumberProxy) -> Content) {
        self.computePageCount = computePageCount
        self.content = content
    }
}
