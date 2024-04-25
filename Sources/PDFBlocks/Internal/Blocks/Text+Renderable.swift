/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Text: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let result = context.renderer.sizeForCTText(format.format(input), environment: environment, proposedSize: proposal)
        return BlockSize(min: result.min, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let remainder = context.renderer.renderCTText(format.format(input), environment: environment, rect: rect)
        if remainder.count > 0 {
            return Text<StringFormatStyle>.init(remainder)
        } else {
            return nil
        }
    }
}

//extension CTText: Renderable {
//    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
//        let result = context.renderer.sizeForCTText(input, environment: environment, proposedSize: proposal)
//        return BlockSize(min: result.min, max: result.max)
//    }
//
//    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
//        let remainder = context.renderer.renderCTText(input, environment: environment, rect: rect)
//        if remainder.count > 0 {
//            return CTText(remainder)
//        } else {
//            return nil
//        }
//    }
//}
