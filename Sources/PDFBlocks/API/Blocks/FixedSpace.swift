/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A spacer block for use in HStack or VStack..
public struct FixedSpace: Block {
    let size: Size

    public init(size: Size) {
        self.size = size
    }
}
