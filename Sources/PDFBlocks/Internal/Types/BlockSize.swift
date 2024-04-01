/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// A type used in the Renderable protocol for block sizing. This allows for
// representation of the minimum and maximum size of blocks that can have
// flexible sizes.
struct BlockSize {
    let min: CGSize
    let max: CGSize
}

extension BlockSize {
    // Is a block flexibile horizontally?
    var hFlexible: Bool {
        max.width != min.width
    }

    // Is a block flexibile horizontally?
    var vFlexible: Bool {
        max.height != min.height
    }
}
