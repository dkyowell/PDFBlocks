/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct TextContinuationModeKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var textContinuationMode: Bool {
        get { self[TextContinuationModeKey.self] }
        set { self[TextContinuationModeKey.self] = newValue }
    }
}
