/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func clipped() -> some Block {
        modifier(ClipRegionModifier())
    }
}
