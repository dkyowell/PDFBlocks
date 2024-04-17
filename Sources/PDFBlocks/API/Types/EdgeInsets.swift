/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type for expressing edge insets.
///
/// Used for page margins and block padding.
public struct EdgeInsets: Equatable {
    public var top: Dimension
    public var leading: Dimension
    public var bottom: Dimension
    public var trailing: Dimension

    public init(top: Dimension = .pt(0), leading: Dimension = .pt(0), bottom: Dimension = .pt(0), trailing: Dimension = .pt(0)) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }

    public init(top: Dimension) {
        self.top = top
        leading = .pt(0)
        bottom = .pt(0)
        trailing = .pt(0)
    }

    public init(leading: Dimension) {
        top = .pt(0)
        self.leading = leading
        bottom = .pt(0)
        trailing = .pt(0)
    }

    public init(bottom: Dimension) {
        top = .pt(0)
        leading = .pt(0)
        self.bottom = bottom
        trailing = .pt(0)
    }

    public init(trailing: Dimension) {
        top = .pt(0)
        leading = .pt(0)
        bottom = .pt(0)
        self.trailing = trailing
    }

    public init(_ value: Dimension) {
        top = value
        leading = value
        bottom = value
        trailing = value
    }

    public static func pt(_ value: CGFloat) -> EdgeInsets {
        .init(top: .pt(value), leading: .pt(value), bottom: .pt(value), trailing: .pt(value))
    }

    public static func `in`(_ value: CGFloat) -> EdgeInsets {
        .init(top: .in(value), leading: .in(value), bottom: .in(value), trailing: .in(value))
    }

    public static func mm(_ value: CGFloat) -> EdgeInsets {
        .init(top: .mm(value), leading: .mm(value), bottom: .mm(value), trailing: .mm(value))
    }
}
