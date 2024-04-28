/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that draws a line.
///
/// Like a `Shape`, a `Line` will take all of the space that it is offered,
public struct Line: Block {
    let start: UnitPoint
    let end: UnitPoint

    public init(start: UnitPoint, end: UnitPoint) {
        self.start = start
        self.end = end
    }
}
