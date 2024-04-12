/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct RenderModeKey: EnvironmentKey {
    static let defaultValue = RenderMode.measured
}

enum RenderMode {
    case measured
    case wrapping
}

extension EnvironmentValues {
    var renderMode: RenderMode {
        get { self[RenderModeKey.self] }
        set { self[RenderModeKey.self] = newValue }
    }
}




struct PageNoReaderKey: EnvironmentKey {
    static let defaultValue: () -> Int = {1}
}

extension EnvironmentValues {
    var pageNo: () -> Int {
        get { self[PageNoReaderKey.self] }
        set { self[PageNoReaderKey.self] = newValue}
    }
}
