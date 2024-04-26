/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// The type of truncation to apply to a line of text when it's too long to
/// fit in the available width.
///
/// When a text block contains more text than it's able to display, the block
/// might truncate the text and place an ellipsis (...) at the truncation
/// point. Use the ``Block/truncationMode(_:)`` modifier with one of the
/// `TruncationMode` values to indicate which part of the text to
/// truncate, either at the beginning, in the middle, or at the end.
public enum TextTruncationMode: Sendable {
    /// Truncate at the beginning of the line.
    ///
    /// Use this kind of truncation to omit characters from the beginning of
    /// the string. For example, you could truncate the English alphabet as
    /// "...wxyz".
    case head

    /// Truncate at the end of the line.
    ///
    /// Use this kind of truncation to omit characters from the end of the
    /// string. For example, you could truncate the English alphabet as
    /// "abcd...".
    case tail

    /// Truncate in the middle of the line.
    ///
    /// Use this kind of truncation to omit characters from the middle of
    /// the string. For example, you could truncate the English alphabet as
    /// "ab...yz".
    case middle

}
