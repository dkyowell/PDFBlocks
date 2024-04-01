/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Text: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        let result = context.renderer.sizeForText(format.format(input), environment: environment, proposedSize: proposedSize)
        return .init(min: result.min, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        context.renderer.renderText(format.format(input), environment: environment, rect: rect)
    }
}
