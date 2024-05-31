//
//  EitherBlock+Renderable.swift
//
//
//  Created by David Yowell on 4/28/24.
//

import Foundation

extension EitherBlock: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        switch value {
        case let .trueContent(content):
            content.getRenderable(environment: environment)
                .getTrait(context: context, environment: environment, keypath: keypath)
        case let .falseContent(content):
            content.getRenderable(environment: environment)
                .getTrait(context: context, environment: environment, keypath: keypath)
        }
    }

    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        switch value {
        case let .trueContent(content):
            content.getRenderable(environment: environment)
                .remainder(context: context, environment: environment, size: size)
        case let .falseContent(content):
            content.getRenderable(environment: environment)
                .remainder(context: context, environment: environment, size: size)
        }
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        switch value {
        case let .trueContent(content):
            content.getRenderable(environment: environment)
                .sizeFor(context: context, environment: environment, proposal: proposal)
        case let .falseContent(content):
            content.getRenderable(environment: environment)
                .sizeFor(context: context, environment: environment, proposal: proposal)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        switch value {
        case let .trueContent(content):
            content.getRenderable(environment: environment)
                .render(context: context, environment: environment, rect: rect)
        case let .falseContent(content):
            content.getRenderable(environment: environment)
                .render(context: context, environment: environment, rect: rect)
        }
    }
}
