/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Text: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let result = context.renderer.sizeForText(value, environment: environment, proposedSize: proposal)
        return BlockSize(min: result.min, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let remainder = context.renderer.renderText(value, environment: environment, rect: rect)
        if remainder.characters.count > 0 {
            return Text(remainder)
        } else {
            return nil
        }
    }
}

extension Text {
    func decompose(context: Context, environment: EnvironmentValues, proposal: Proposal) -> [any Renderable] {
        context.renderer.decomposeText(value, environment: environment, proposedSize: proposal)
            .map { Text($0) }
    }
}
