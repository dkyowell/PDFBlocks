/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func scaleEffect(_ scale: CGSize, anchor: UnitPoint = .center) -> some Block {
        modifier(ScaleModifier(scale: scale, anchor: anchor))
    }

    func scaleEffect(_ s: CGFloat, anchor: UnitPoint = .center) -> some Block {
        modifier(ScaleModifier(scale: .init(width: s, height: s), anchor: anchor))
    }

    func scaleEffect(x: CGFloat = 1, y: CGFloat = 1, anchor: UnitPoint = .center) -> some Block {
        modifier(ScaleModifier(scale: .init(width: x, height: y), anchor: anchor))
    }
}
