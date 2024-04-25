/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block for displaying text.
public struct Text: Block {
    let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init<F>(_ input: F.FormatInput, format: F) where F: FormatStyle, F.FormatInput: Equatable, F.FormatOutput == String {
        value = format.format(input)
    }
}

public struct CGText: Block {
    let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init<F>(_ input: F.FormatInput, format: F) where F: FormatStyle, F.FormatInput: Equatable, F.FormatOutput == String {
        value = format.format(input)
    }
}
