/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A custom parameter attribute that constructs table groups from closures
@resultBuilder
public struct TableGroupBuilder<RowValue> {
    public typealias T = any TableGroupContent<RowValue>

    public static func buildExpression(_ content: T) -> T {
        content
    }

    public static func buildBlock() -> [T] {
        []
    }

    public static func buildBlock(_ content: T...) -> [T] {
        var result: [T] = content
        // Chain groups.
        for index in result.indices.dropLast() {
            result[index].nextGroup = result[result.index(after: index)]
        }
        return result
    }
}
