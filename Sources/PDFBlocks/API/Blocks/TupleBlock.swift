/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A  block returned by `@BlockBuilder` when a block has
/// has multiple elements for its contents.
///
/// Users should not need to use `TupleBlock` explicitly.
public struct TupleBlock<V>: Block {
    let _blocks: [any Block]

    public init<each T>(_ value: V) where repeat each T: Block, V == (repeat each T) {
        // In Swift 5.9, one of the only things that can be done with a type pack is to call a
        // method on each element. That is done here with an inout paramater to load an array.
        var array: [any Block] = []
        (repeat (each value).appendToArray(&array))
        _blocks = array
    }
}
