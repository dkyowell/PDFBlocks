/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Text: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let result = context.renderer.sizeForCTText(value, environment: environment, proposedSize: proposal)
        return BlockSize(min: result.min, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let remainder = context.renderer.renderCTText(value, environment: environment, rect: rect)
        if remainder.count > 0 {
            return Text(remainder)
        } else {
            return nil
        }
    }
}

extension CGText: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let result = context.renderer.sizeForText(format.format(input), environment: environment, proposedSize: proposal)
        return BlockSize(min: result.min, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        context.renderer.renderText(format.format(input), environment: environment, rect: rect)
        return nil
    }
}
