/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type for expressing 2D size.
public struct Size {
    public let width: Dimension
    public let height: Dimension

    public init(width: Dimension, height: Dimension) {
        self.width = width
        self.height = height
    }
}
