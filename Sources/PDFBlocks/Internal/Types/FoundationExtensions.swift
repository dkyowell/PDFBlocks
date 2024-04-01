/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension CGSize {
    func scaled(by factor: CGFloat) -> CGSize {
        .init(width: width * factor, height: height * factor)
    }
}

extension CGPoint {
    func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        .init(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    func rectInCenter(size: CGSize) -> CGRect {
        .init(origin: .init(x: minX + (width - size.width) / 2, y: minY + (height - size.height) / 2),
              size: size)
    }
}
