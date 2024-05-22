//
//  EitherBlock+Renderable.swift
//
//
//  Created by David Yowell on 4/28/24.
//

import Foundation

extension EitherBlock: Renderable {
    // TODO: Trait, Remainder, etc.

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        switch value {
        case let .trueContent(content):
            let node = content.getRenderable(environment: environment)
            return node.sizeFor(context: context, environment: environment, proposal: proposal)
        case let .falseContent(content):
            let node = content.getRenderable(environment: environment)
            return node.sizeFor(context: context, environment: environment, proposal: proposal)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        switch value {
        case let .trueContent(content):
            let node = content.getRenderable(environment: environment)
            return node.render(context: context, environment: environment, rect: rect)
        case let .falseContent(content):
            let node = content.getRenderable(environment: environment)
            return node.render(context: context, environment: environment, rect: rect)
        }
    }
}
