/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Block {
    // Used by TupleBlock to extract the contents of a variadic generic parameter to an array.
    func appendToArray(_ array: inout [any Block]) {
        array.append(self)
    }
}
