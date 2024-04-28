/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block for printing text.
public struct Text: Block {
    let value: String

    /// Creates a text view that displays a string value.
    ///
    /// - Parameters:
    ///   - value: A string value to print.
    public init(_ value: String) {
        self.value = value
    }

    /// Creates a text view that prints the formatted representation
    /// of a nonstring type supported by a corresponding format style.
    ///
    /// - Parameters:
    ///   - input: The underlying value to print.
    ///   - format: A format style of type `F` to convert the underlying value
    ///     of type `F.FormatInput` to a string representation.
    public init<F>(_ input: F.FormatInput, format: F) where F: FormatStyle, F.FormatInput: Equatable, F.FormatOutput == String {
        value = format.format(input)
    }
}
