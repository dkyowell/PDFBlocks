/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A property wrapper that reads a value from a block's environment.
@propertyWrapper public struct Environment<Value> {
    init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }

    private let keyPath: KeyPath<EnvironmentValues, Value>
    @MutableValue var environment: EnvironmentValues?

    public var wrappedValue: Value {
        guard let environment else {
            fatalError("EnvironmentValues not present.")
        }
        return environment[keyPath: keyPath]
    }
}
