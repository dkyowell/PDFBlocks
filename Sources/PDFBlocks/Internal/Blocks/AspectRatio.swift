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
    // TODO: See Debug+AspectRatio. Behavior is not the same as SwiftUI. SwiftUI seems to apply
    // aspect ratios in limited circumstances that I do not understand.
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

    // TODO: Not sure about contentSize
    func contentSize(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content.getRenderable(environment: environment)
            .contentSize(context: context, environment: environment, proposal: proposal)
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
