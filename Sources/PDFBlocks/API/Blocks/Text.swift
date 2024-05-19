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
/// Use .truncationMode(:) to specify how to lay out
/// `Text` when it is larger than its frame. The
/// default truncation mode is .none, which means
/// the entire text value will be printed, even if it
/// overflows its container. Use .tail to truncate
/// the text string with an ellipsis so that it fits
/// its frame. Use .wrap to wrap the text into the
/// next column or page when its container allows
/// for it.
///
public struct Text: Block {
    let value: NSAttributedString

    /// Creates a text block that displays a string value.
    ///
    /// - Parameters:
    ///   - value: A string value to print.
    public init(_ value: String) {
        self.value = NSAttributedString(string: value)
    }

    public init(_ value: AttributedString) {
        self.value = NSAttributedString(value)
    }

    public init(_ value: NSAttributedString) {
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
        value = NSAttributedString(string: format.format(input))
    }
}
