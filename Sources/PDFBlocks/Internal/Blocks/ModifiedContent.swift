/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension ModifiedContent: Renderable where Content: Block, Modifier: BlockModifier {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        let nmc = _BlockModifier_Content(modifier: modifier, block: content)
        let modifiedContent = modifier.body(content: nmc)
        let block = modifiedContent.getRenderable(environment: environment)
        return block.sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let nmc = _BlockModifier_Content(modifier: modifier, block: content)
        let modifiedContent = modifier.body(content: nmc)
        let block = modifiedContent.getRenderable(environment: environment)
        block.render(context: context, environment: environment, rect: rect)
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        let nmc = _BlockModifier_Content(modifier: modifier, block: content)
        let modifiedContent = modifier.body(content: nmc)
        let block = modifiedContent.getRenderable(environment: environment)
        return block.getTrait(context: context, environment: environment, keypath: keypath)
    }
}

// TODO: Determine whether Pages can have modifiers.
extension ModifiedContent where Content: PageBlock, Modifier: BlockModifier {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
//        let nmc = _BlockModifier_Content(modifier: modifier, block: content)
//        let modifiedContent = modifier.body(content: nmc)
        let block = ErrorMessageBlock(message: "Oops").getRenderable(environment: environment)
        return block.sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
//        let nmc = _BlockModifier_Content(modifier: modifier, block: content)
//        let modifiedContent = modifier.body(content: nmc)
//        let block = modifiedContent.getPrimitiveBlock(environment: environment)
        let block = ErrorMessageBlock(message: "Oops").getRenderable(environment: environment)
        block.render(context: context, environment: environment, rect: rect)
    }
}

extension ModifiedContent: GroupBlock where Content: GroupBlock, Modifier: BlockModifier {
    var blocks: [any Block] {
        content.flattenedBlocks().map { AnyBlock($0).modifier(modifier) }
    }
}
