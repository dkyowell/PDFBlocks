/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

enum LayoutAxis {
    case horizontal
    case vertical
    case undefined
}

struct LayoutAxisKey: EnvironmentKey {
    static let defaultValue = LayoutAxis.undefined
}

extension EnvironmentValues {
    var layoutAxis: LayoutAxis {
        get { self[LayoutAxisKey.self] }
        set { self[LayoutAxisKey.self] = newValue }
    }
}
