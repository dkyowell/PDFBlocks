/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// A MultipageBlock that can contain other blocks will set isWithinMultipageContainer
// to true during its sizing and rendering methods.
private struct IsWithinMultipageContainerKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isWithinMultipageContainer: Bool {
        get { self[IsWithinMultipageContainerKey.self] }
        set { self[IsWithinMultipageContainerKey.self] = newValue }
    }
}
