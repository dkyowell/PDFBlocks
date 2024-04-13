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

    public mutating func move(to end: CGPoint) {
        _mutablePath?.move(to: end)
    }

    public mutating func addLine(to end: CGPoint) {
        _mutablePath?.addLine(to: end)
    }

    public mutating func closeSubpath() {
        _mutablePath?.closeSubpath()
    }
}
