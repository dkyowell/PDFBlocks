/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A spacer block for use in HStack or VStack..
public struct FixedSpace: Block {
    let length: Size
    let direction: Direction

    public init(width: Size) {
        length = width
        direction = .width
    }

    public init(height: Size) {
        length = height
        direction = .height
    }

    enum Direction {
        case width
        case height
    }
}
