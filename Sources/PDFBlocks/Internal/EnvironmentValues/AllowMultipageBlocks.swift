/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// A Block that does not allow multipage blocks within its contents will set allowMultiPageBlocks to false with an
// associated value of its block name. The associated value is used in error reporting.
enum AllowMultipageBlocks {
    case `true`
    case `false`(String)
}

private struct AllowMultipageBlocksKey: EnvironmentKey {
    static let defaultValue = AllowMultipageBlocks.true
}

extension EnvironmentValues {
    var allowMultipageBlocks: AllowMultipageBlocks {
        get { self[AllowMultipageBlocksKey.self] }
        set { self[AllowMultipageBlocksKey.self] = newValue }
    }
}
