/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// A property wrapper purposed for use in value types in order to allow them to have the
// ergonomics of having mutable value type properties. This is Swift "syntactic sugar"
// that is accomplished by wrapping a value type within a reference type.
@propertyWrapper class MutableValue<T> {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}
