/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct MultipagePadding<Content>: MultipageBlock where Content: MultipageBlock {
    let top: Size
    let bottom: Size
    let content: Content
}

extension MultipagePadding: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        if case let .false(outerBlock) = environment.allowMultipageBlocks {
            ErrorMessageBlock(message: errorMessage(innerBlock: "MultipagePadding", outerBlock: outerBlock))
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
            ErrorMessageBlock(message: errorMessage(innerBlock: "MultipagePadding", outerBlock: outerBlock))
                .getRenderable(environment: environment)
                .render(context: context, environment: environment, rect: rect)
            return
        }
        var environment = environment
        if environment.isWithinMultipageContainer == false {
            environment.isWithinMultipageContainer = true
            context.beginMultipageRendering(rect: rect)
        }
        context.advanceMultipageCursor(top.points)
        let block = content.getRenderable(environment: environment)
        block.render(context: context, environment: environment, rect: rect)
        context.advanceMultipageCursor(bottom.points)
    }

    func proportionalWidth(environment _: EnvironmentValues) -> Double? {
        nil
    }
}

extension MultipageBlock {
    func errorMessage(innerBlock: String, outerBlock: String) -> String {
        "\(innerBlock) cannot be used within a \(outerBlock). \(outerBlock) cannot properly handle page overflows."
    }
}
