/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that prints an image.
public struct Image: Block {
    let image: PlatformImage

    public init(_ image: PlatformImage) {
        self.image = image
    }
}
