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

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func contentSize(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content.getRenderable(environment: environment)
            .contentSize(context: context, environment: environment, proposal: proposal)
    }

    // TODO: Should a ClippedRegion return a remainder? What about contentSize?
    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        context.renderer.starClipRegion(rect: rect)
        content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        context.renderer.endClipRegion()
        return nil
    }
}

struct ClipRegionModifier: BlockModifier {
    func body(content: Content) -> some Block {
        ClipRegion(content: content)
    }
}
