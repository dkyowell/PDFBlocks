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
        let remainder = block.render(context: context, environment: environment, rect: rect)
        context.renderer.renderBorder(environment: environment, rect: rect, shapeStyle: shapeStyle, width: width.points)
        if let content = remainder as? AnyBlock {
            return Border<AnyBlock>(shapeStyle: shapeStyle, width: width, content: content)
        } else {
            return nil
        }
    }
}

struct BorderModifier: BlockModifier {
    let shapeStyle: ShapeStyle
    let width: Dimension

    func body(content: Content) -> some Block {
        Border(shapeStyle: shapeStyle, width: width, content: content)
    }
}
