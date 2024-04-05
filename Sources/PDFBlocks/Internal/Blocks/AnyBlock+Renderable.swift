/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension AnyBlock: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        let block = content.getRenderable(environment: environment)
        return block.sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let block = content.getRenderable(environment: environment)
        block.render(context: context, environment: environment, rect: rect)
    }

    func proportionalWidth(environment: EnvironmentValues) -> Double? {
        content.getRenderable(environment: environment)
            .proportionalWidth(environment: environment)
    }
}
