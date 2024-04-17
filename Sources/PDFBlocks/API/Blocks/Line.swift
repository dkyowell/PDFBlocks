/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A horizontal line.
public struct Line: Block {
    let thickness: Dimmension
    let dash: [CGFloat]

    public init(thickness: Dimmension = .pt(1), dash: [CGFloat] = []) {
        self.thickness = thickness
        self.dash = dash
    }
}
