/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public protocol Shape: Block {
    func path(in rect: CGRect) -> Path
}

public extension Shape {
    var body: some Block {
        RenderableShape(shape: self)
    }
}
