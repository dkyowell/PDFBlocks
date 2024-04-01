/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type for expressing page size.
public struct PageSize {
    public let width: Size
    public let height: Size

    public init(width: Size, height: Size) {
        self.width = width
        self.height = height
    }
}

public extension PageSize {
    static var letter: Self {
        .init(width: .in(8.5), height: .in(11))
    }

    static var legal: Self {
        .init(width: .in(8.5), height: .in(14))
    }

    static var tabloid: Self {
        .init(width: .in(11), height: .in(17))
    }

    static var a4: Self {
        .init(width: .mm(210), height: .mm(297))
    }

    static var a5: Self {
        .init(width: .mm(148), height: .mm(210))
    }
}
