/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Text: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let result = context.renderer.sizeForText(format.format(input), environment: environment, proposedSize: proposal)
        return .init(min: result.min, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        context.renderer.renderText(format.format(input), environment: environment, rect: rect)
        return nil
    }
}

extension CTText: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let result = context.renderer.sizeForCTText(input, environment: environment, proposedSize: proposal)
        // print("result", proposedSize, input, result)
        return BlockSize(min: .zero, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
//        context.renderer.renderText(input, environment: environment, rect: rect)
//        return nil
        let remainder = context.renderer.renderCTText(input, environment: environment, rect: rect)
        if remainder.count > 0 {
            return CTText(remainder)
        } else {
            return nil
        }
    }
}
