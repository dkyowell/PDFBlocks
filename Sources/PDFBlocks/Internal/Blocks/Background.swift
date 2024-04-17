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
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let renderable = background.getRenderable(environment: environment)
        if renderable.isSecondaryPageWrapBlock(context: context, environment: environment) {
            renderable.render(context: context, environment: environment, rect: rect)
        } else {
            let size = renderable.sizeFor(context: context, environment: environment, proposedSize: rect.size)
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
            renderable.render(context: context, environment: environment, rect: renderRect)
            content.getRenderable(environment: environment)
                .render(context: context, environment: environment, rect: rect)
        }
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }
}

struct BackgroundModifier<BackgroundContent>: BlockModifier where BackgroundContent: Block {
    let background: BackgroundContent
    let alignment: Alignment

    func body(content: Content) -> some Block {
        Background(content: content, background: background, alignment: alignment)
    }
}
