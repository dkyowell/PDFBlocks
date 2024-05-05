/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct AspectRatio<Content>: Block where Content: Block {
    let value: CGFloat
    let content: Content
}

extension AspectRatio: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }

    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        content.getRenderable(environment: environment)
            .remainder(context: context, environment: environment, size: size)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let block = content.getRenderable(environment: environment)
        let size = block.sizeFor(context: context, environment: environment, proposal: proposal)
        if size.min != size.max {
            let constrainedSize = if proposal.width < proposal.height {
                CGSize(width: proposal.width, height: proposal.width / value)
            } else {
                CGSize(width: proposal.height * value, height: proposal.height)
            }
            return BlockSize(constrainedSize)
        } else {
            return size
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let remainder = content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        if let content = remainder as? AnyBlock {
            return AspectRatio<AnyBlock>(value: value, content: content)
        } else {
            return nil
        }
    }
}

struct AspectRatioModifier: BlockModifier {
    let value: CGFloat

    func body(content: Content) -> some Block {
        AspectRatio(value: value, content: content)
    }
}
