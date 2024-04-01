/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension ForEach: GroupBlock {
    var blocks: [any Block] {
        data.map { AnyBlock(content($0)) }
    }
}
