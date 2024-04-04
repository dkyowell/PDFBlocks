/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that occupies no space and renders no content.
public struct EmptyBlock: Block {
    /// Creates an EmptyBlock.
    public init() {}
}
