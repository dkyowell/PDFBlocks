/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct EnvironmentValues {
    var values: [String: Any] = [:]

    public subscript<K>(key: K.Type) -> K.Value where K: EnvironmentKey {
        get {
            let keyString = String(describing: key)
            return (values[keyString] as? K.Value) ?? K.defaultValue
        }
        set {
            let keyString = String(describing: key)
            values[keyString] = newValue
        }
    }
}

public protocol EnvironmentKey<Value> {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}
