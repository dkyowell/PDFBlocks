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
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        let renderable = content.getRenderable(environment: environment)
        if renderable.isSecondaryPageWrapBlock(context: context, environment: environment) {
            return BlockSize(width: proposedSize.width, height: 0)
        } else {
            let constrainedSize = if proposedSize.width < proposedSize.height {
                CGSize(width: proposedSize.width, height: proposedSize.width / value)
            } else {
                CGSize(width: proposedSize.height * value, height: proposedSize.height)
            }
            let size = renderable.sizeFor(context: context, environment: environment, proposedSize: constrainedSize)
            return .init(min: size.min, max: size.max)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }
}

struct AspectRatioModifier: BlockModifier {
    let value: CGFloat

    func body(content: Content) -> some Block {
        AspectRatio(value: value, content: content)
    }
}
