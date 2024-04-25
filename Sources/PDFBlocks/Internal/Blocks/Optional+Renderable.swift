/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Optional: Renderable where Wrapped: Block {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        if let self {
            let block = self.getRenderable(environment: environment)
            return block.sizeFor(context: context, environment: environment, proposal: proposal)
        } else {
            return .init(min: .zero, max: .zero)
        }
    }

    // TODO: ContentSize?

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        if let self {
            let block = self.getRenderable(environment: environment)
            return block.render(context: context, environment: environment, rect: rect)
        } else {
            return nil
        }
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        if let self {
            self.getRenderable(environment: environment)
                .getTrait(context: context, environment: environment, keypath: keypath)
        } else {
            Trait()[keyPath: keypath]
        }
    }
}
