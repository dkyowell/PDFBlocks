/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A vertical stack that can span multiple pages.
public struct MultipageStack<Content>: MultipageBlock where Content: Block {
    let spacing: Size
    let content: Content

    public init(spacing: Size = .pt(0), @BlockBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
}
