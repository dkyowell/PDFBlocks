/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Block {
    func rotationEffect(_ angle: Angle, anchor: UnitPoint = .center) -> some Block {
        modifier(RotationModifier(angle: angle, anchor: anchor))
    }
}
