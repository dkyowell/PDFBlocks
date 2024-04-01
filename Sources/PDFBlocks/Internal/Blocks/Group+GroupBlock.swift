/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Group: GroupBlock {
    var blocks: [any Block] {
        if let cast = content as? GroupBlock {
            cast.blocks
        } else {
            [content]
        }
    }
}
