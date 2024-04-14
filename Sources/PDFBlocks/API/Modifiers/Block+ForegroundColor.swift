/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets the foreground color for a block.
    func foregroundColor(_ value: Color) -> some Block {
        environment(\.foregroundStyle, value)
    }
}
