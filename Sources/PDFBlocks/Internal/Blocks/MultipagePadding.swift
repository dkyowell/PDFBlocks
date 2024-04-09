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
        } else if context.multipageMode {
            BlockSize(width: proposedSize.width, height: 0)
        } else {
            BlockSize(proposedSize)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        if case let .false(outerBlock) = environment.allowMultipageBlocks {
            ErrorMessageBlock(message: errorMessage(innerBlock: "MultipagePadding", outerBlock: outerBlock))
                .getRenderable(environment: environment)
                .render(context: context, environment: environment, rect: rect)
            return
        }
        if context.multipageMode == false {
            context.beginMultipageRendering(environment: environment, pageFrame: nil, rect: rect)
        }
        context.advanceMultipageCursor(top.points)
        let block = content.getRenderable(environment: environment)
        block.render(context: context, environment: environment, rect: rect)
        context.advanceMultipageCursor(bottom.points)
    }
}

extension MultipageBlock {
    func errorMessage(innerBlock: String, outerBlock: String) -> String {
        "\(innerBlock) cannot be used within a \(outerBlock). \(outerBlock) cannot properly handle page overflows."
    }
}
