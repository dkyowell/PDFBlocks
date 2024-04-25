/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct Columns<Content>: Block where Content: Block {
    let count: Int
    let spacing: Dimension
    let allowWrap: Bool
    let content: Content

    public init(count: Int, spacing: Dimension, allowWrap: Bool = false, @BlockBuilder content: () -> Content) {
        self.count = max(1, count)
        self.spacing = spacing
        self.allowWrap = allowWrap
        self.content = content()
    }
}
