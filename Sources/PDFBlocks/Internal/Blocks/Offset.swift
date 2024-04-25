/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct Offset<Content>: Block where Content: Block {
    let x: Dimension
    let y: Dimension
    let content: Content
}

extension Offset: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let block = content.getRenderable(environment: environment)
        context.renderer.startOffset(x: x.points, y: y.points)
        let remainder = block.render(context: context, environment: environment, rect: rect)
        context.renderer.restoreState()
        if let content = remainder as? AnyBlock {
            return Offset<AnyBlock>(x: x, y: y, content: content)
        } else {
            return nil
        }
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }
}

struct OffsetModifier: BlockModifier {
    let x: Dimension
    let y: Dimension

    func body(content: Content) -> some Block {
        Offset(x: x, y: y, content: content)
    }
}
