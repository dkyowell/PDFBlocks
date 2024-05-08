/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Repeat: GroupBlock {
    var blocks: [any Block] {
        Array(repeating: content, count: count)
    }
}
