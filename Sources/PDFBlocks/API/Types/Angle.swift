/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public struct Angle {
    public var radians: Double

    public var degrees: Double {
        radians * 180 / .pi
    }

    public init() {
        radians = 0
    }

    public init(radians: Double) {
        self.radians = radians
    }

    public init(degrees: Double) {
        radians = degrees * .pi / 180
    }

    public static func radians(_ radians: Double) -> Angle {
        Angle(radians: radians)
    }

    public static func degrees(_ degrees: Double) -> Angle {
        Angle(degrees: degrees)
    }
}
