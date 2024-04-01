/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension TupleBlock: GroupBlock {
    var blocks: [any Block] {
        _blocks
    }
}
