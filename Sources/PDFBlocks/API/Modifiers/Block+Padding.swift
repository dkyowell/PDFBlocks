/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func padding(_ edges: Set<Edge>, _ length: Dimension) -> some Block {
        let top = edges.contains(.top) ? length : .pt(0)
        let leading = edges.contains(.leading) ? length : .pt(0)
        let bottom = edges.contains(.bottom) ? length : .pt(0)
        let trailing = edges.contains(.trailing) ? length : .pt(0)
        return modifier(PaddingModifier(padding: .init(top: top, leading: leading, bottom: bottom, trailing: trailing)))
    }

    func padding(_ length: Dimension) -> some Block {
        padding(.all, length)
    }

    func padding(top: Dimension = .pt(0), leading: Dimension = .pt(0), bottom: Dimension = .pt(0), trailing: Dimension = .pt(0)) -> some Block {
        modifier(PaddingModifier(padding: .init(top: top, leading: leading, bottom: bottom, trailing: trailing)))
    }
}
