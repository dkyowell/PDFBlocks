/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Alignment {
    // The horizontal portion of a 2D Alignment.
    var horizontalAlignment: HorizontalAlignment {
        switch self {
        case .leading, .topLeading, .bottomLeading:
            .leading
        case .center, .top, .bottom:
            .center
        case .trailing, .topTrailing, .bottomTrailing:
            .trailing
        }
    }

    // The vertical portion of a 2D Alignment.
    var verticalAlignment: VerticalAlignment {
        switch self {
        case .top, .topLeading, .topTrailing:
            .top
        case .center, .leading, .trailing:
            .center
        case .bottom, .bottomLeading, .bottomTrailing:
            .bottom
        }
    }
}
