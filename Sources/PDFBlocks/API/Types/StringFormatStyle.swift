/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A FormatStyle for String that does nothing.
///
/// This is needed because all text blacks and table columns require a format style,
/// even when the value if the input of the text or column is a string and no
/// formatting is required.
public struct StringFormatStyle: Foundation.FormatStyle {
    public func format(_ value: String) -> String {
        value
    }
}
