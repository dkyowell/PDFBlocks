/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func proportionalFrame(width: CGFloat = 1, alignment: HorizontalAlignment = .leading) -> some Block {
        ProporionalFrame(width: width, horizontalAlignment: alignment, content: self)
    }
}

