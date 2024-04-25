/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension ModifiedContent: Renderable where Content: Block, Modifier: BlockModifier {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let nmc = _BlockModifier_Content(modifier: modifier, block: content)
        let modifiedContent = modifier.body(content: nmc)
        let block = modifiedContent.getRenderable(environment: environment)
        return block.sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func contentSize(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let nmc = _BlockModifier_Content(modifier: modifier, block: content)
        let modifiedContent = modifier.body(content: nmc)
        let block = modifiedContent.getRenderable(environment: environment)
        return block.contentSize(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let nmc = _BlockModifier_Content(modifier: modifier, block: content)
        let modifiedContent = modifier.body(content: nmc)
        let block = modifiedContent.getRenderable(environment: environment)
        let remainder = block.render(context: context, environment: environment, rect: rect)
        // TODO: I don't think this gets called.
        if let remainder {
            return remainder
        } else {
//        if let content = remainder as? Content {
//
//            return ModifiedContent(content: content, modifier: modifier)
//        } else {
            return nil
        }
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        let nmc = _BlockModifier_Content(modifier: modifier, block: content)
        let modifiedContent = modifier.body(content: nmc)
        let block = modifiedContent.getRenderable(environment: environment)
        return block.getTrait(context: context, environment: environment, keypath: keypath)
    }
}

extension ModifiedContent: GroupBlock where Content: GroupBlock, Modifier: BlockModifier {
    var blocks: [any Block] {
        content.flattenedBlocks().map { AnyBlock($0).modifier(modifier) }
    }
}
