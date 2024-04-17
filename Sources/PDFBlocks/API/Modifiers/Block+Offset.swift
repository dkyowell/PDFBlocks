/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func offset(x: Dimmension, y: Dimmension) -> some Block {
        modifier(OffsetModifier(x: x, y: y))
    }

    func offset(_ offset: Size) -> some Block {
        modifier(OffsetModifier(x: offset.width, y: offset.height))
    }
}
