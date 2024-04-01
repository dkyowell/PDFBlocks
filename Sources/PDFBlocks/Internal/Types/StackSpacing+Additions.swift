/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension StackSpacing {
    // A function used by Stacks to determine the width of their spacing.
    var fixedPoints: CGFloat {
        switch self {
        case let .flex(value):
            // The min spacing is a flex spacing is counted as fixedPoints
            value.points
        case let .fixed(value):
            value.points
        }
    }
}
