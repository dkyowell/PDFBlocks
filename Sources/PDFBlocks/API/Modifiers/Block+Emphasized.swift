/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets emphasized value of block.
    func emphasized(_ value: Bool = true) -> some Block {
        environment(\.emphasized, value)
    }
}

struct EmphasizedKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var emphasized: Bool {
        get { self[EmphasizedKey.self] }
        set { self[EmphasizedKey.self] = newValue }
    }
}
