/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that computes blocks on demand from an underlying array of data.
public struct ForEach<T, Content>: Block where Content: Block {
    let content: (T) -> Content
    let data: [T]

    public init(data: [T], @BlockBuilder content: @escaping (T) -> Content) {
        self.data = data
        self.content = content
    }
}
