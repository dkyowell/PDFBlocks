/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct ArrayBlock: Block {
    let blocks: [any Block]
}

extension ArrayBlock: GroupBlock {}
