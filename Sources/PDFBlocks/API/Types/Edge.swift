//
//  Edge.swift
//
//
//  Created by David Yowell on 4/5/24.
//

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

    /// Add a collection of edges to a collection of edges.
    /// - Parameter edges: The collection of edges.
    /// - Returns: Both collections combined.
    func add(_ edges: Self) -> Self { union(edges) }
}
