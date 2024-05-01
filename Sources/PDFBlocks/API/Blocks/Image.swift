/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that prints an image.
///
/// An `Image` is always resizable and will always
/// retain its native aspectRatio.
public struct Image: Block {
    let image: PlatformImage

    /// Creates an Image from an instance of a `PlatformImage`
    /// - Parameter image: A platform defined image type.
    public init(_ image: PlatformImage) {
        self.image = image
    }
}
