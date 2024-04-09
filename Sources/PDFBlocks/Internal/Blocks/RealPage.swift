//
//  RealPage.swift
//
//
//  Created by David Yowell on 4/9/24.
//

import Foundation

// The Page block merely offers a Trait.pageInfo value. RealPage is an internal block that Context will
struct RealPage<Content>: Renderable where Content: Block {
    let size: PageSize
    let content: Content

    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize _: ProposedSize) -> BlockSize {
        BlockSize(width: size.width.points, height: size.height.points)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let pageSize = CGSize(width: size.width.points, height: size.height.points)
        context.startNewPage(newPageSize: pageSize)
        let block = content.getRenderable(environment: environment)
        block.render(context: context, environment: environment, rect: rect)
    }

    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait()[keyPath: keypath]
    }
}
