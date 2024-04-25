/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// The rendering context wraps Page with RealPage. Page provides rendering context witha PageInfo and it applies
// margins for its content.
//
// By design:
//   .background or .overlay on page will be full bleed and not within the margins
//   .padding on a page will increase the pages margins
extension Page: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposal: Proposal) -> BlockSize {
        BlockSize(proposal)
    }

    @discardableResult func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let marginRect = CGRect(x: rect.minX + pageInfo.margins.leading.points,
                                y: rect.minY + pageInfo.margins.top.points,
                                width: rect.width - pageInfo.margins.leading.points - pageInfo.margins.trailing.points,
                                height: rect.height - pageInfo.margins.top.points - pageInfo.margins.bottom.points)
        let block = content.getRenderable(environment: environment)
        let size = block.sizeFor(context: context, environment: environment, proposal: marginRect.size).max
        let dx: CGFloat = (marginRect.width - size.width) / 2.0
        let dy: CGFloat = (marginRect.height - size.height) / 2.0
        let renderRect = CGRect(origin: marginRect.origin.offset(dx: dx, dy: dy), size: size)
        block.render(context: context, environment: environment, rect: renderRect)
        return nil
    }

    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(pageInfo: pageInfo)[keyPath: keypath]
    }
}
