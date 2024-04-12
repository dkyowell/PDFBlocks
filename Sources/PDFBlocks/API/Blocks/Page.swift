/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that defines an entire PDF page.
///
/// A page can have a background, overlay, or frame, but it should
/// not be embedded in a stack or given padding or a frame.
public struct Page<Content>: Block where Content: Block {
    let pageInfo: PageInfo
    // Page is dynamically generated so that @Environment(\.pageNo) will work
    let content: () -> Content

    public init(size: PageSize, margins: EdgeInsets, @BlockBuilder content: @escaping () -> Content) {
        pageInfo = .init(size: size, margins: margins)
        self.content = content
    }
}
