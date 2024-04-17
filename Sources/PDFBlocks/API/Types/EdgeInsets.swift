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
    public var top: Dimmension
    public var leading: Dimmension
    public var bottom: Dimmension
    public var trailing: Dimmension

    public init(top: Dimmension = .pt(0), leading: Dimmension = .pt(0), bottom: Dimmension = .pt(0), trailing: Dimmension = .pt(0)) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }

    public init(top: Dimmension) {
        self.top = top
        leading = .pt(0)
        bottom = .pt(0)
        trailing = .pt(0)
    }

    public init(leading: Dimmension) {
        top = .pt(0)
        self.leading = leading
        bottom = .pt(0)
        trailing = .pt(0)
    }

    public init(bottom: Dimmension) {
        top = .pt(0)
        leading = .pt(0)
        self.bottom = bottom
        trailing = .pt(0)
    }

    public init(trailing: Dimmension) {
        top = .pt(0)
        leading = .pt(0)
        bottom = .pt(0)
        self.trailing = trailing
    }

    public init(_ value: Dimmension) {
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
