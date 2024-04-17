/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct ScaleEffect<Content>: Block where Content: Block {
    let scale: CGSize
    let anchor: UnitPoint
    let content: Content
}

extension ScaleEffect: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        context.renderer.startScale(scale: scale, anchor: anchor, rect: rect)
        content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        context.renderer.restoreState()
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }
}

struct ScaleModifier: BlockModifier {
    let scale: Size
    let anchor: UnitPoint

    func body(content: Content) -> some Block {
        ScaleEffect(scale: .init(width: scale.width.points, height: scale.height.points), anchor: anchor, content: content)
    }
}
