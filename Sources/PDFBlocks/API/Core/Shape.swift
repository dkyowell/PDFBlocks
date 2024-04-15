/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A 2D shape that you can use when drawing a block.
///
/// Shapes without an explicit fill or stroke get a default fill based on the
/// foreground color.
public protocol Shape: Block {
    func path(in rect: CGRect) -> Path
    func sizeThatFits(_ proposal: CGSize) -> CGSize
}

public extension Shape {
    var body: some Block {
        RenderableShape(shape: self)
    }
}

public extension Shape {
    func sizeThatFits(_ proposal: CGSize) -> CGSize {
        proposal
    }
}
