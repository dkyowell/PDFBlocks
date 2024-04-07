/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block for use within PageFrame that will take all availible
/// space and communicate the space to the PageFrame by way
/// of an environment value.
struct PageFrameReader: Block {
    public init() {}
}
