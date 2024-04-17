/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Block {
    func offset(x: Size, y: Size) -> some Block {
        modifier(OffsetModifier(x: x, y: y))
    }
}
