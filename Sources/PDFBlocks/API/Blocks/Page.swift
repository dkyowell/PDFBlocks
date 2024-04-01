/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that defines an entire PDF page.
public struct Page<Content>: Block where Content: Block {
    let size: PageSize
    let margins: EdgeInsets
    let content: Content
    public init(size: PageSize, margins: EdgeInsets, @BlockBuilder content: () -> Content) {
        self.size = size
        self.margins = margins
        self.content = content()
    }
}
