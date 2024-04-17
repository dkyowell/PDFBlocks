/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type for expressing the spacing between elements
/// in a stack.
public enum StackSpacing {
    case flex(min: Dimension)
    case fixed(Dimension)
}

public extension StackSpacing {
    static var none: StackSpacing {
        .fixed(.pt(0))
    }

    static var flex: StackSpacing {
        .flex(min: .pt(0))
    }

    static func pt(_ value: CGFloat) -> StackSpacing {
        .fixed(.pt(value))
    }

    static func `in`(_ value: CGFloat) -> StackSpacing {
        .fixed(.in(value))
    }

    static func mm(_ value: CGFloat) -> StackSpacing {
        .fixed(.mm(value))
    }
}
