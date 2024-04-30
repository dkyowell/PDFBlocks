/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block for printing text.
///
/// Text can render a string as in this example.
///
///     Text("What's taters, precious?")
///
/// It can also render other types when passed a FormatStyle.
///
///     Text(Date(), format: .dateTime)
///
/// A `Text` will expand to fill all of its availible
/// space, printing a trailing ellipsis if there is more
/// of a string that cannot be rendered. When the
/// pageWrap behavior of its container allows, a
/// text block will continue printing on a new column
/// or a new page if necessary.
///
public struct Text: Block {
    let value: String

    /// Creates a text block that displays a string value.
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
