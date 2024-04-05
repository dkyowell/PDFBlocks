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
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        var environment = environment
        environment[keyPath: keyPath] = value
        let block = content.getRenderable(environment: environment)
        return block.sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment[keyPath: keyPath] = value
        let block = content.getRenderable(environment: environment)
        block.render(context: context, environment: environment, rect: rect)
    }

    func proportionalWidth(environment: EnvironmentValues) -> Double? {
        var environment = environment
        environment[keyPath: keyPath] = value
        let block = content.getRenderable(environment: environment)
        return block.proportionalWidth(environment: environment)
    }
}

struct EnvironmentModifier<V>: BlockModifier {
    let keyPath: WritableKeyPath<EnvironmentValues, V>
    let value: V

    func body(content: Content) -> some Block {
        EnvironmentBlock(keyPath: keyPath, value: value, content: content)
    }
}
