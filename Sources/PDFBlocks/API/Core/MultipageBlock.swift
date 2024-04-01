/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A special class of blocks that allow their content to span page boundaries.
///
/// Multipage blocks have an indeterminate height that can span multiple pages,
/// so they cannot be embedded within: VStack, HStack, ZStack, and ColumnStack;
/// nor can they have the following modifiers: aspectRatio, border, frame, padding,
/// background, or overlay.
///
/// There is a special verticalPadding modifier that allows for vertical padding
/// before and after a multipage block.
public protocol MultipageBlock: Block {}

public extension MultipageBlock {
    func multipagePadding(top: Size = .pt(0), bottom: Size = .pt(0)) -> some Block {
        MultipagePadding(top: top, bottom: bottom, content: self)
    }

    func multipagePadding(vertical: Size) -> some Block {
        multipagePadding(top: vertical, bottom: vertical)
    }
}
