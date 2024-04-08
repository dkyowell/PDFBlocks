/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A spacer block for use in HStack or VStack.
///
/// AT PRESENT SPACER FUNCTIONALITY DOES NOT
/// MATCH SWIFTUI. IN SWIFTUI, SPACER HAS A
/// LAYOUTPRIORITY OF LESS THAN 0. LAYOUT PRIORITY
/// SUPPORT HAS NOT BEEN ADDED.
public struct Spacer: Block {
    let minLength: Size

    public init(minLength: Size = .pt(0)) {
        self.minLength = minLength
    }
}
