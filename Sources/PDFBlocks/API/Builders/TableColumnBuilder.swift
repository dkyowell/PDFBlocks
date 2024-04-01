/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A custom parameter attribute that constructs table columns from closures
@resultBuilder
public struct TableColumnBuilder<RowValue> {
    public typealias T = any TableColumnContent<RowValue>

    public static func buildExpression(_ content: T) -> T {
        content
    }

    public static func buildBlock() -> [T] {
        []
    }

    public static func buildBlock(_ content: T...) -> [T] {
        content
    }
}
