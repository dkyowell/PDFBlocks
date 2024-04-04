/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Sets the alignment of a text block that contains multiple lines of text.
    ///
    /// Use this modifier to set an alignment for a multiline block of text.
    /// For example, the modifier centers the contents of the following
    /// ``Text`` block:
    ///
    ///     Text("This is a block of text that shows up in a text element as multiple lines.")
    ///         .frame(width: .in(2))
    ///         .multilineTextAlignment(.center)
    ///
    /// - Parameter alignment: The alignment value to apply.
    /// - Returns: A block for which the given opacity has been set.
    func multilineTextAlignment(_ alignment: TextAlignment) -> some Block {
        environment(\.multilineTextAlignment, alignment)
    }
}

struct MultilineTextAlignmentKey: EnvironmentKey {
    static let defaultValue: TextAlignment = .leading
}

extension EnvironmentValues {
    var multilineTextAlignment: TextAlignment {
        get { self[MultilineTextAlignmentKey.self] }
        set { self[MultilineTextAlignmentKey.self] = newValue }
    }
}
