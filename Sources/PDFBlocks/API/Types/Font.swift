/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct Font {
    let name: String
    let size: CGFloat
}

#if os(macOS) || os(iOS)
    public extension Font {
        init(_ font: NSUIFont) {
            name = font.fontName
            size = font.pointSize
        }
    }
#endif
