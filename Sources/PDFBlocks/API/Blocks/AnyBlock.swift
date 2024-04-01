/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type-erased block.
public struct AnyBlock: Block {
    let content: any Block

    public init(_ content: any Block) {
        self.content = content
    }
}
