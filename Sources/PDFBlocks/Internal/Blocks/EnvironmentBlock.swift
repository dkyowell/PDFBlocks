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
    func getTrait<X>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, X>) -> X {
        var environment = environment
        environment[keyPath: keyPath] = value
        return content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }

    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        var environment = environment
        environment[keyPath: keyPath] = value
        return content.getRenderable(environment: environment)
            .remainder(context: context, environment: environment, size: size)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        var environment = environment
        environment[keyPath: keyPath] = value
        return content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment[keyPath: keyPath] = value
        return content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
    }
}

struct EnvironmentModifier<V>: BlockModifier {
    let keyPath: WritableKeyPath<EnvironmentValues, V>
    let value: V

    func body(content: Content) -> some Block {
        EnvironmentBlock(keyPath: keyPath, value: value, content: content)
    }
}
