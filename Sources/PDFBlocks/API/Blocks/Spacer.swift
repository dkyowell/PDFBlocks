/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// An invisible spacer block for use within a layout block.
///
/// Spacer will adapt its orientation according to the layout axis
/// of the layout block within which it is contained.
///
/// Almost anything that can be done with a fixed length spacer can also
/// be accomplished with a `padding` modifier. There is one exception:
/// When used with in a `VStack` that allows page wraps, a spacer will be
/// ignored if it is the first item within the stack on a new page.
///
/// AT PRESENT SPACER FUNCTIONALITY DOES NOT
/// MATCH SWIFTUI. IN SWIFTUI, SPACER HAS A
/// LAYOUTPRIORITY OF LESS THAN 0. LAYOUT PRIORITY
/// SUPPORT HAS NOT BEEN ADDED.
///
public struct Spacer: Block {
    enum SpacerValue {
        case fixed(Dimension)
        case min(Dimension)
    }

    let value: SpacerValue

    /// Creates a flexible spacer with no minimum length..
    ///
    public init() {
        value = .min(0)
    }

    /// Creates a flexible spacer.
    ///
    /// - Parameters:
    ///   - minLength: The spacer will be at least this length.
    public init(minLength: Dimension) {
        value = .min(minLength)
    }

    /// Creates a fixed length spacer.
    ///
    /// - Parameters:
    ///   - fixedLength: The length of a spacer.
    public init(fixedLength: Dimension) {
        value = .fixed(fixedLength)
    }
}
