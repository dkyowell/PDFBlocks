/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import CoreGraphics
import Foundation

public struct Path {
    var _cgPath: CGPath?

    var _mutablePath: CGMutablePath?

    var cgPath: CGPath {
        _cgPath ?? _mutablePath?.copy() ?? CGPath(ellipseIn: .zero, transform: .none)
    }

    public init(_ rect: CGRect) {
        _cgPath = CGPath(rect: rect, transform: .none)
    }

    public init(roundedRect: CGRect, cornerRadius: CGFloat) {
        _cgPath = CGPath(roundedRect: roundedRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius,
                         transform: .none)
    }

    public init(ellipseIn rect: CGRect) {
        _cgPath = CGPath(ellipseIn: rect, transform: .none)
    }

    public init() {
        _mutablePath = CGMutablePath()
    }

    public init(_ callback: (inout Path) -> Void) {
        _mutablePath = CGMutablePath()
        callback(&self)
    }

    /// Begins a new subpath at the specified point.
    ///
    /// The specified point becomes the start point of a new subpath.
    /// The current point is set to this start point.
    ///
    /// - Parameter end: The point, in user space coordinates, at which
    ///   to start a new subpath.
    ///
    public mutating func move(to end: CGPoint) {
        _mutablePath?.move(to: end)
    }

    /// Appends a straight line segment from the current point to the
    /// specified point.
    ///
    /// After adding the line segment, the current point is set to the
    /// endpoint of the line segment.
    ///
    /// - Parameter end: The location, in user space coordinates, for the
    ///   end of the new line segment.
    ///
    public mutating func addLine(to end: CGPoint) {
        _mutablePath?.addLine(to: end)
    }

    public mutating func addQuadCurve(to end: CGPoint, control: CGPoint) {
        _mutablePath?.addQuadCurve(to: end, control: control)
    }

    public mutating func addCurve(to end: CGPoint, control1: CGPoint, control2: CGPoint) {
        _mutablePath?.addCurve(to: end, control1: control1, control2: control2)
    }

    public mutating func closeSubpath() {
        _mutablePath?.closeSubpath()
    }

    public mutating func addRect(_ rect: CGRect, transform: CGAffineTransform = .identity) {
        _mutablePath?.addRect(rect, transform: transform)
    }

    public mutating func addRoundedRect(in rect: CGRect, cornerSize: CGSize, transform: CGAffineTransform = .identity) {
        _mutablePath?.addRoundedRect(in: rect, cornerWidth: cornerSize.width, cornerHeight: cornerSize.height, transform: transform)
    }

    public mutating func addEllipse(in rect: CGRect, transform: CGAffineTransform = .identity) {
        _mutablePath?.addEllipse(in: rect, transform: transform)
    }

    public mutating func addRects(_ rects: [CGRect], transform: CGAffineTransform = .identity) {
        _mutablePath?.addRects(rects, transform: transform)
    }

    public mutating func addLines(_ lines: [CGPoint]) {
        _mutablePath?.addLines(between: lines)
    }

    public mutating func addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: Angle, delta: Angle, transform: CGAffineTransform = .identity) {
        _mutablePath?.addRelativeArc(center: center, radius: radius, startAngle: startAngle.radians, delta: delta.radians, transform: transform)
    }

    public mutating func addArc(center: CGPoint, radius: CGFloat, startAngle: Angle, endAngle: Angle, clockwise: Bool, transform: CGAffineTransform = .identity) {
        _mutablePath?.addArc(center: center, radius: radius, startAngle: startAngle.radians, endAngle: endAngle.radians, clockwise: clockwise, transform: transform)
    }

    public mutating func addPath(_ path: Path, transform: CGAffineTransform = .identity) {
        _mutablePath?.addPath(path.cgPath, transform: transform)
    }

    public var currentPoint: CGPoint? {
        _mutablePath?.currentPoint
    }
}
