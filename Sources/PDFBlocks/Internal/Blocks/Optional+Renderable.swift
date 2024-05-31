/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Optional: Renderable where Wrapped: Block {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        if let self {
            self.getRenderable(environment: environment)
                .getTrait(context: context, environment: environment, keypath: keypath)
        } else {
            Trait()[keyPath: keypath]
        }
    }

    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        self?.getRenderable(environment: environment)
            .remainder(context: context, environment: environment, size: size)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        if let self {
            self.getRenderable(environment: environment)
                .sizeFor(context: context, environment: environment, proposal: proposal)
        } else {
            BlockSize(.zero)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        self?.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
    }
}
