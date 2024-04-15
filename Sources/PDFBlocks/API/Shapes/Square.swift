/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct Square: Shape {
    public init() {}

    public func path(in rect: CGRect) -> Path {
        let length = min(rect.width, rect.height)
        let size = CGSize(width: length, height: length)
        let origin = CGPoint(x: (rect.width - length) / 2, y: (rect.height - length) / 2)
        return Path(CGRect(origin: origin, size: size))
    }

    public func sizeThatFits(_ proposal: CGSize) -> CGSize {
        let minLength = min(proposal.width, proposal.height)
        return .init(width: minLength, height: minLength)
    }
}
