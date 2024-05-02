/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct EnvironmentBlock<Content, V>: Block where Content: Block {
    let keyPath: WritableKeyPath<EnvironmentValues, V>
    let value: V
    let content: Content
}

extension EnvironmentBlock: Renderable {
    func decompose(context: Context, environment: EnvironmentValues, proposal: Proposal) -> [any Renderable] {
        var environment = environment
        environment[keyPath: keyPath] = value
        let block = content.getRenderable(environment: environment)
        return block.getRenderable(environment: environment)
            .decompose(context: context, environment: environment, proposal: proposal)
            .map { EnvironmentBlock<AnyBlock, V>(keyPath: keyPath, value: value, content: AnyBlock($0)) }
    }

    func getTrait<X>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, X>) -> X {
        var environment = environment
        environment[keyPath: keyPath] = value
        let block = content.getRenderable(environment: environment)
        return block.getTrait(context: context, environment: environment, keypath: keypath)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
        environment[keyPath: keyPath] = value
        let block = content.getRenderable(environment: environment)
        return block.sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment[keyPath: keyPath] = value
        let block = content.getRenderable(environment: environment)
        let remainder = block.render(context: context, environment: environment, rect: rect)
        if let content = remainder as? AnyBlock {
            return EnvironmentBlock<AnyBlock, V>(keyPath: keyPath, value: value, content: content)
        } else {
            return nil
        }
    }
}

struct EnvironmentModifier<V>: BlockModifier {
    let keyPath: WritableKeyPath<EnvironmentValues, V>
    let value: V

    func body(content: Content) -> some Block {
        EnvironmentBlock(keyPath: keyPath, value: value, content: content)
    }
}

//
//
// struct EntireEnvironmentBlock<Content>: Block where Content: Block {
//    let value: EnvironmentValues
//    let content: Content
// }
//
// extension EntireEnvironmentBlock: Renderable {
//
//
//    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
//        let environment = value
//        let block = content.getRenderable(environment: environment)
//        return block.sizeFor(context: context, environment: environment, proposal: proposal)
//    }
//
//    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
//        let environment = value
//        let block = content.getRenderable(environment: environment)
//        let remainder = block.render(context: context, environment: environment, rect: rect)
//        if let content = remainder as? AnyBlock {
//            return EntireEnvironmentBlock<AnyBlock>(value: value, content: content)
//        } else {
//            return nil
//        }
//    }
// }
