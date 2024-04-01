/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A type for expressing a font name.
///
/// FontName allows for users to define extensions that can be
/// used for code completion without littering the String namespace:
///
///     extension FontName {
///         static var helveitcaRegular: FontName {"Helvetica"}
///         static var helveticaLight: FontName {"Helvetica-Light"}
///     }
///
///     struct MyBlock: Block {
///         var body: some Block {
///             Text("Hello")
///                 .font(name: .helveticaRegular)
///         }
///     }
///
public struct FontName: ExpressibleByStringLiteral {
    public let value: String
    public init(stringLiteral: String) {
        value = stringLiteral
    }
}
