/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct RotationEffect<Content>: Block where Content: Block {
    let angle: Angle
    let anchor: UnitPoint
    let content: Content
}

extension RotationEffect: Renderable {
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
        let block = content.getRenderable(environment: environment)
        context.renderer.startRotation(angle: angle.radians, anchor: anchor, rect: rect)
        let remainder = block.render(context: context, environment: environment, rect: rect)
        context.renderer.restoreState()
        if let content = remainder as? AnyBlock {
            return RotationEffect<AnyBlock>(angle: angle, anchor: anchor, content: content)
        } else {
            return nil
        }
    }
}

struct RotationModifier: BlockModifier {
    let angle: Angle
    let anchor: UnitPoint

    func body(content: Content) -> some Block {
        RotationEffect(angle: angle, anchor: anchor, content: content)
    }
}
