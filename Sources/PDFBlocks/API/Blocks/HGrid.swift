/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A grid can span multiple pages.
public struct HGrid<Content>: Block where Content: Block {
    let columnCount: Int
    let columnSpacing: Dimension
    let rowSpacing: Dimension
    let allowPageWrap: Bool
    let content: Content

    public init(columnCount: Int,
                columnSpacing: Dimension,
                rowSpacing: Dimension,
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
