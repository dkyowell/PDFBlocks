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
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        context.renderer.startOpacity(opacity: opacity)
        content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        context.renderer.restoreOpacity()
    }
}

struct OpacityModifier: BlockModifier {
    let opacity: CGFloat

    func body(content: Content) -> some Block {
        Opacity(opacity: opacity, content: content)
    }
}
