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
        context.renderer.startRotation(angle: angle.radians, anchor: anchor, rect: rect)
        content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        context.renderer.restoreState()
    }
}

struct RotationModifier: BlockModifier {
    let angle: Angle
    let anchor: UnitPoint

    func body(content: Content) -> some Block {
        RotationEffect(content: content, angle: angle, anchor: anchor)
    }
}
