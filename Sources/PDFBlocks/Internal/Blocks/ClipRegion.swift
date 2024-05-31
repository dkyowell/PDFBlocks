/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct ClipRegion<Content>: Block where Content: Block {
    let content: Content
}

extension ClipRegion: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }

    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        content.getRenderable(environment: environment)
            .remainder(context: context, environment: environment, size: size)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        context.renderer.starClipRegion(rect: rect)
        let remainder = content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        context.renderer.endClipRegion()
        return remainder
    }
}

struct ClipRegionModifier: BlockModifier {
    func body(content: Content) -> some Block {
        ClipRegion(content: content)
    }
}
