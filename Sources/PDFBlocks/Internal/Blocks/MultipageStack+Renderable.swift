/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension MultipageStack: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        if case let .false(outerBlock) = environment.allowMultipageBlocks {
            ErrorMessageBlock(message: errorMessage(innerBlock: "MultipageStack", outerBlock: outerBlock))
                .getRenderable(environment: environment)
                .sizeFor(context: context, environment: environment, proposedSize: proposedSize)
        } else if environment.isWithinMultipageContainer {
            .init(min: .init(width: proposedSize.width, height: 0),
                  max: .init(width: proposedSize.width, height: 0))
        } else {
            .init(min: proposedSize,
                  max: proposedSize)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        if case let .false(outerBlock) = environment.allowMultipageBlocks {
            ErrorMessageBlock(message: errorMessage(innerBlock: "MultipageStack", outerBlock: outerBlock))
                .getRenderable(environment: environment)
                .render(context: context, environment: environment, rect: rect)
            return
        }
        var environment = environment
        if environment.isWithinMultipageContainer == false {
            environment.isWithinMultipageContainer = true
            context.beginMultipageRendering(rect: rect)
        }
        let blocks = content.getRenderables(environment: environment)
        for (offset, block) in blocks.enumerated() {
            if offset > 0 {
                context.advanceMultipageCursor(spacing.points)
            }
            context.renderMultipageContent(block: block, environment: environment)
        }
    }

    func proportionalWidth(environment _: EnvironmentValues) -> Double? {
        nil
    }
}
