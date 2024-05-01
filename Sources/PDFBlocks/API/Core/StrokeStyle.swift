/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
#if os(iOS)
    import UIKit
#endif
#if os(macOS)
    import AppKit
#endif

/// The characteristics of a stroke that traces a path.
public struct StrokeStyle {
    /// The width of the stroked path.
    public var lineWidth: Dimension

    /// The endpoint style of a line.
    public var lineCap: CGLineCap

    /// The join type of a line.
    public var lineJoin: CGLineJoin

    /// A threshold used to determine whether to use a bevel instead of a
    /// miter at a join.
    public var miterLimit: CGFloat

    /// The lengths of painted and unpainted segments used to make a dashed line.
    public var dash: [CGFloat]

    /// How far into the dash pattern the line starts.
    public var dashPhase: CGFloat

    /// Creates a new stroke style from the given components.
    ///
    /// - Parameters:
    ///   - lineWidth: The width of the segment.
    ///   - lineCap: The endpoint style of a segment.
    ///   - lineJoin: The join type of a segment.
    ///   - miterLimit: The threshold used to determine whether to use a bevel
    ///     instead of a miter at a join.
    ///   - dash: The lengths of painted and unpainted segments used to make a
    ///     dashed line.
    ///   - dashPhase: How far into the dash pattern the line starts.
    public init(lineWidth: Dimension = .pt(1), lineCap: CGLineCap = .butt, lineJoin: CGLineJoin = .miter, miterLimit: CGFloat = 10,
                dash: [CGFloat] = [CGFloat](), dashPhase: CGFloat = 0)
    {
        self.lineWidth = lineWidth
        self.lineCap = lineCap
        self.lineJoin = lineJoin
        self.miterLimit = miterLimit
        self.dash = dash
        self.dashPhase = dashPhase
    }
}
