/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension RadialGradient: Block {
    public var body: some Block {
        Rectangle()
            .fill(self)
    }
}
