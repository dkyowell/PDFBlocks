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
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let renderable = background.getRenderable(environment: environment)
        let size = renderable.sizeFor(context: context, environment: environment, proposal: rect.size)
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
        let remainder = content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        if let content = remainder as? AnyBlock {
            return Background<AnyBlock, BackgroundContent>.init(content: content, background: background, alignment: alignment)
        } else {
            return nil
        }
    }
}

struct BackgroundModifier<BackgroundContent>: BlockModifier where BackgroundContent: Block {
    let background: BackgroundContent
    let alignment: Alignment

    func body(content: Content) -> some Block {
        Background(content: content, background: background, alignment: alignment)
    }
}
