/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */
import Foundation

private extension FloatingPoint {
    var kround: Self {
        (self * 1000).rounded(.awayFromZero)
    }
}

infix operator ~<=: ComparisonPrecedence

public func ~<=<F>(left:F, right:F) -> Bool where F: FloatingPoint {
    return left.kround <= right.kround
}

infix operator ~>=: ComparisonPrecedence

public func ~>=<F>(left:F, right:F) -> Bool where F: FloatingPoint {
    return left.kround >= right.kround
}

infix operator ~<: ComparisonPrecedence

public func ~<<F>(left:F, right:F) -> Bool where F: FloatingPoint {
    return left.kround < right.kround
}

infix operator ~>: ComparisonPrecedence

public func ~><F>(left:F, right:F) -> Bool where F: FloatingPoint {
    return left.kround > right.kround
}

infix operator ~==: ComparisonPrecedence

public func ~==<F>(left:F, right:F) -> Bool where F: FloatingPoint {
    return left.kround == right.kround
}
