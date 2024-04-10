/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A grid can span multiple pages.
public struct Grid<Content>: Block where Content: Block {
    let columnCount: Int
    let columnSpacing: Size
    let rowSpacing: Size
    let allowPageWrap: Bool
    let content: Content

    public init(columnCount: Int,
                columnSpacing: Size,
                rowSpacing: Size,
                allowPageWrap: Bool = false,
                @BlockBuilder content: () -> Content)
    {
        self.columnCount = max(1, columnCount)
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
        self.allowPageWrap = allowPageWrap
        self.content = content()
    }
}
