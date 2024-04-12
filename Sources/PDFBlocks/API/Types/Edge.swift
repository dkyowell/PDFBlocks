/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public enum Edge {
    case top
    case leading
    case bottom
    case trailing
}

public extension Set<Edge> {
    /// Horizontal and vertical edges.
    static var all: Self { [.top, .leading, .bottom, .trailing] }

    /// Top and bottom edges.
    static var vertical: Self { [.top, .bottom] }

    /// Leading and trailing edges.
    static var horizontal: Self { [.leading, .trailing] }

    /// Top edge.
    static var top: Self { [.top] }

    /// Bottom edge.
    static var bottom: Self { [.bottom] }

    /// Leading edge.
    static var leading: Self { [.leading] }

    /// Trailing edge.
    static var trailing: Self { [.trailing] }
}
