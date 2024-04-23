/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public enum ContentMode {
    /// An option that resizes the content so it's all within the available space,
    /// both vertically and horizontally.
    ///
    /// This mode preserves the content's aspect ratio.
    /// If the content doesn't have the same aspect ratio as the available
    /// space, the content becomes the same size as the available space on
    /// one axis and leaves empty space on the other.
    case fit

    /// An option that resizes the content so it occupies all available space,
    /// both vertically and horizontally.
    ///
    /// This mode preserves the content's aspect ratio.
    /// If the content doesn't have the same aspect ratio as the available
    /// space, the content becomes the same size as the available space on
    /// one axis, and larger on the other axis.
    // case fill
}
