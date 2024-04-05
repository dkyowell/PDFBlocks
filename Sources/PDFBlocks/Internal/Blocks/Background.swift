/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct Background<Content, BackgroundContent>: Block where Content: Block, BackgroundContent: Block {
    let content: Content
    let background: BackgroundContent
    let alignment: Alignment
}

extension Background: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        var environment = environment
        environment.allowMultipageBlocks = .false("Background")
        return content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.allowMultipageBlocks = .false("Background")
        let block = background.getRenderable(environment: environment)
        let size = block.sizeFor(context: context, environment: environment, proposedSize: rect.size)
        let dx: CGFloat =
            switch alignment.horizontalAlignment {
            case .leading:
                0
            case .center:
                (rect.width - size.max.width) / 2.0
            case .trailing:
                rect.width - size.max.width
            }
        let dy: CGFloat =
            switch alignment.verticalAlignment {
            case .top:
                0
            case .center:
                (rect.height - size.max.height) / 2.0
            case .bottom:
                rect.height - size.max.height
            }
        let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size.max)
        block.render(context: context, environment: environment, rect: renderRect)
        content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
    }

    func proportionalWidth(environment: EnvironmentValues) -> Double? {
        content.getRenderable(environment: environment)
            .proportionalWidth(environment: environment)
    }
}
