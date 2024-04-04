/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A  block that takes multipage content as its content and
/// a frame that will be printed around the content on each page.
struct PageFrame<Frame, Content>: Block where Frame: Block, Content: Block {
    let frame: (Int) -> Frame
    let content: Content

    public init(@BlockBuilder frame: @escaping (Int) -> Frame, @BlockBuilder content: () -> Content) {
        self.frame = frame
        self.content = content()
    }
}
