/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct RotationEffect<Content>: Block where Content: Block {
    let content: Content
    let angle: Angle
    let anchor: UnitPoint
}

extension RotationEffect: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let renderable = content.getRenderable(environment: environment)
        if renderable.isSecondaryPageWrapBlock(context: context, environment: environment) {
            renderable.render(context: context, environment: environment, rect: rect)
        } else {
            context.renderer.startRotation(angle: angle.radians, anchor: anchor, rect: rect)
            renderable.render(context: context, environment: environment, rect: rect)
            context.renderer.restoreState()
        }
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }
}

struct RotationModifier: BlockModifier {
    let angle: Angle
    let anchor: UnitPoint

    func body(content: Content) -> some Block {
        RotationEffect(content: content, angle: angle, anchor: anchor)
    }
}
