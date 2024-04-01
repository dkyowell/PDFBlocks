/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// This protocol is the mechanism by which a block's @Environment property is
// updated. With the use of Mirror, a block's properties are scanned to see
// which conform to EnvironmentProperty and .update(:) is called on the
// conforming properties.
protocol EnvironmentProperty {
    func update(_ value: EnvironmentValues)
}

extension Environment: EnvironmentProperty {
    func update(_ value: EnvironmentValues) {
        environment = value
    }
}
