/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets the truncation mode for lines of text that are too long to fit in
    /// the available width.
    ///
    /// Use the `truncationMode(_:)` modifier to determine whether text in a
    /// long line is truncated at the beginning, middle, or end. Truncation is
    /// indicated by adding an ellipsis (…) to the line when removing text to
    /// indicate to readers that text is missing.
    ///
    /// In the example below, the bounds of text block constrains the amount of
    /// text that the block displays and the `truncationMode(_:)` specifies from
    /// which direction and where to display the truncation indicator:
    ///
    ///     Text("This is a block of text that shows up in a text element as multiple lines.")
    ///         .frame(width: .in(1), height: .in(1))
    ///         .truncationMode(.tail)
    ///
    /// - Parameter mode: The truncation mode that specifies where to truncate
    ///   the text within the text block, if needed. You can truncate at the
    ///   beginning, middle, or end of the text block.
    ///
    /// - Returns: A block that truncates text at different points in a line
    ///   depending on the mode you select.
    func truncationMode(_ mode: TextTruncationMode) -> some Block {
        environment(\.truncationMode, mode)
    }
}

struct TruncationModeKey: EnvironmentKey {
    static let defaultValue: TextTruncationMode = .tail
}

extension EnvironmentValues {
    var truncationMode: TextTruncationMode {
        get { self[TruncationModeKey.self] }
        set { self[TruncationModeKey.self] = newValue }
    }
}
