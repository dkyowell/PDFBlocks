/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct Border<Content>: Block where Content: Block {
    let shapeStyle: ShapeStyle
    let width: Dimension
    let content: Content
}

extension Border: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        context.renderer.renderBorder(environment: environment, rect: rect, shapeStyle: shapeStyle,
                                      width: width.points)
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }
}

struct BorderModifier: BlockModifier {
    let shapeStyle: ShapeStyle
    let width: Dimension

    func body(content: Content) -> some Block {
        Border(shapeStyle: shapeStyle, width: width, content: content)
    }
}
