/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// TODO: Prevent from being applied on a secondary page wrap region
public extension Block {
    func scaleEffect(_ scale: Size, anchor: UnitPoint = .center) -> some Block {
        modifier(ScaleModifier(scale: scale, anchor: anchor))
    }

    func scaleEffect(_ s: Dimmension, anchor: UnitPoint = .center) -> some Block {
        modifier(ScaleModifier(scale: .init(width: s, height: s), anchor: anchor))
    }

    func scaleEffect(x: Dimmension = .pt(1), y: Dimmension = .pt(1), anchor: UnitPoint = .center) -> some Block {
        modifier(ScaleModifier(scale: .init(width: x, height: y), anchor: anchor))
    }
}
