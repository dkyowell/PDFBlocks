/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func kerning(_ kerning: CGFloat) -> some Block {
        environment(\.kerning, kerning)
    }
}

struct KerningKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    var kerning: CGFloat {
        get {
            self[KerningKey.self]
        }
        set {
            self[KerningKey.self] = newValue
        }
    }
}
