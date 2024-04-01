/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type for expressing  horizontal and vertical alignment.
public enum Alignment {
    case top
    case center
    case bottom
    case leading
    case trailing
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
}

/// A type for expressing  horizontal alignment.
public enum HorizontalAlignment {
    case leading
    case center
    case trailing
}

/// A type for expressing  vertical alignment.
public enum VerticalAlignment {
    case top
    case center
    case bottom
}
