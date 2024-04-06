/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Optional: Renderable where Wrapped: Block {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        if let self {
            let block = self.getRenderable(environment: environment)
            return block.sizeFor(context: context, environment: environment, proposedSize: proposedSize)
        } else {
            return .init(min: .zero, max: .zero)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        if let self {
            let block = self.getRenderable(environment: environment)
            block.render(context: context, environment: environment, rect: rect)
        }
    }

    func proportionalWidth(environment: EnvironmentValues) -> Double? {
        if let self {
            self.getRenderable(environment: environment)
                .proportionalWidth(environment: environment)
        } else {
            nil
        }
    }
}
