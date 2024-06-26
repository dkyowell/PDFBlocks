/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func textStroke(color: Color = Color.black, lineWidth: CGFloat = 3.0) -> some Block {
        environment(\.textStroke, TextStroke(color: color, lineWidth: lineWidth))
    }
}

struct TextStrokeKey: EnvironmentKey {
    static let defaultValue: TextStroke? = nil
}

extension EnvironmentValues {
    var textStroke: TextStroke? {
        get { self[TextStrokeKey.self] }
        set { self[TextStrokeKey.self] = newValue }
    }
}
