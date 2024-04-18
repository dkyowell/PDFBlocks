/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// TODO: In SwiftUI, Text is not generic over Format. Investigate implementation.
/// A block for displaying text.
public struct Text<F>: Block where F: FormatStyle, F.FormatInput: Equatable, F.FormatOutput == String {
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

public struct CTText<F>: Block where F: FormatStyle, F.FormatInput: Equatable, F.FormatOutput == String {
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
