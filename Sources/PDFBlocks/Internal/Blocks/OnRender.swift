/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct OnRender<Content>: Block where Content: Block {
    let onRender: () -> Void
    let content: Content
}

extension OnRender: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let block = content.getRenderable(environment: environment)
        return block.sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let block = content.getRenderable(environment: environment)
        let remainder = block.render(context: context, environment: environment, rect: rect)
        onRender()
        if let content = remainder as? AnyBlock {
            return OnRender<AnyBlock>(onRender: onRender, content: content)
        } else {
            return nil
        }
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }
}

struct OnRenderModifier: BlockModifier {
    let onRender: () -> Void

    func body(content: Content) -> some Block {
        OnRender(onRender: onRender, content: content)
    }
}
