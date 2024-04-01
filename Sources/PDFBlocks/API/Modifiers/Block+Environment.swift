/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets the environment value of the specified key path to the given value.
    ///
    /// Use this modifier to set one of the writable properties of the
    /// ``EnvironmentValues`` structure, including custom values that you
    /// create. For example, you can set the value associated with the
    /// ``EnvironmentValues/fontSize`` key:
    ///
    ///     MyBlock()
    ///         .environment(\.fontSize, 12)
    ///
    /// You then read the value inside `MyBlock` or one of its descendants
    /// using the ``Environment`` property wrapper:
    ///
    ///     struct MyBlock: Block {
    ///         @Environment(\.fontSize) var fontSize: CGFloat
    ///
    ///         var body: some Block { ... }
    ///     }
    ///
    /// PDFBuilder provides dedicated block modifiers for setting most
    /// environment values, like the ``Block/font(size:)``
    /// modifier which sets the ``EnvironmentValues/fontSize`` value:
    ///
    ///     MyBlock()
    ///         .font(size: 12)
    ///
    /// Prefer the dedicated modifier when available, and offer your own when
    /// defining custom environment values, as described in
    /// ``EnvironmentKey``.
    ///
    /// This modifier affects the given block,
    /// as well as that block's descendant blocks. It has no effect
    /// outside the block hierarchy on which you call it.
    ///
    /// - Parameters:
    ///   - keyPath: A key path that indicates the property of the
    ///     ``EnvironmentValues`` structure to update.
    ///   - value: The new value to set for the item specified by `keyPath`.
    ///
    /// - Returns: A block that has the given value set in its environment.
    func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, _ value: V) -> some Block {
        modifier(EnvironmentModifier(keyPath: keyPath, value: value))
    }
}
