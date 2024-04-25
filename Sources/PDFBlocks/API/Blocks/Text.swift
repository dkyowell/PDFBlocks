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

public struct CGText<F>: Block where F: FormatStyle, F.FormatInput: Equatable, F.FormatOutput == String {
    let input: F.FormatInput
    let format: F

    public init(_ input: F.FormatInput, format: F) {
        self.input = input
        self.format = format
    }

    public init(_ input: String) where F == StringFormatStyle {
        self.input = input
        format = StringFormatStyle()
    }
}
