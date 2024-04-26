/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct Opacity<Content>: Block where Content: Block {
    let opacity: CGFloat
    let content: Content
}

extension Opacity: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let block = content.getRenderable(environment: environment)
        context.renderer.startOpacity(opacity: opacity)
        let remainder = block.render(context: context, environment: environment, rect: rect)
        context.renderer.restoreOpacity()
        if let remainder = remainder as? AnyBlock {
            return Opacity<AnyBlock>(opacity: opacity, content: remainder)
        } else {
            return nil
        }
    }
}

struct OpacityModifier: BlockModifier {
    let opacity: CGFloat

    func body(content: Content) -> some Block {
        Opacity(opacity: opacity, content: content)
    }
}
