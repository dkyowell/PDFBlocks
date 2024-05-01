/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that draws a line.
///
/// Like a `Shape`, a `Line` will take all of the space that it is offered,
///
/// The following line takes its full offered width, with a height of 2, drawing
/// a lineWidth of 2.
///
///     Line(start: .leading, end: .trailing)
///         .stroke(.black, style: StrokeStyle(lineWidth: 2))
///         .frame(height: 2)
///
/// This example draws a diagonal line, starting 25% of the width away from the leading edge and
/// 25% of the height away from the top. The line ends 75% away from the
/// leading edge and 75% away from the top.
///
///     Line(start: .init(x: 0.25, y: 0.25), end: .init(x: 0.75, y: 0.75))
///
///
public struct Line: Block {
    let start: UnitPoint
    let end: UnitPoint

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///   - start: A unit point within the block that serves as the line origin..
    ///   - end: A unit point within the block that serves as the line end.
    public init(start: UnitPoint, end: UnitPoint) {
        self.start = start
        self.end = end
    }
}
