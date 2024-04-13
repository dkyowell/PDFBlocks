/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public protocol Shape: Block {
    func path(in rect: CGRect) -> Path
}

public extension Shape {
    @BlockBuilder var body: some Block {
        fatalError()
    }
}
