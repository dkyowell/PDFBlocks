/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation


public struct Rectangle: Shape {
    public init() {}

    public func path(in rect: CGRect) -> Path {
        Path(rect)
    }
}
