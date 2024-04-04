/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A horizontal line.
public struct Line: Block {
    let thickness: Size
    let dash: [CGFloat]

    public init(thickness: Size = .pt(1), dash: [CGFloat] = []) {
        self.thickness = thickness
        self.dash = dash
    }
}
