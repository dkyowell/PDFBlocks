/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct RoundedRectangle: Shape {
    let cornerRadius: Size

    public init(cornerRadius: Size) {
        self.cornerRadius = cornerRadius
    }

    public func path(in rect: CGRect) -> Path {
        Path(roundedRect: rect, cornerRadius: cornerRadius.points)
    }
}
