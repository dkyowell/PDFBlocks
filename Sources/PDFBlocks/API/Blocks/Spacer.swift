/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A spacer block for use in HStack or VStack. It can either be
/// a fixed length, or flexible with a minimum length.
///
///
/// NOTE: A `Spacer` has a special property within a  VStack;
/// it will not render when it is the first item on a new page.
///
/// AT PRESENT SPACER FUNCTIONALITY DOES NOT
/// MATCH SWIFTUI. IN SWIFTUI, SPACER HAS A
/// LAYOUTPRIORITY OF LESS THAN 0. LAYOUT PRIORITY
/// SUPPORT HAS NOT BEEN ADDED.
public struct Spacer: Block {
    enum SpacerValue {
        case fixed(Dimension)
        case min(Dimension)
    }

    let value: SpacerValue

    public init() {
        value = .min(0)
    }

    public init(minLength: Dimension) {
        value = .min(minLength)
    }

    public init(fixedLength: Dimension) {
        value = .fixed(fixedLength)
    }
}
