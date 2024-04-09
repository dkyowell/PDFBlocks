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
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        BlockSize(proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let layoutWidth = rect.width - pageInfo.margins.leading.points - pageInfo.margins.trailing.points
        let layoutHeight = rect.height - pageInfo.margins.top.points - pageInfo.margins.bottom.points
        let layoutOriginX = rect.minX + pageInfo.margins.leading.points
        let layoutOrginY = rect.minY + pageInfo.margins.top.points
        let layoutRect = CGRect(origin: .init(x: layoutOriginX, y: layoutOrginY),
                                size: .init(width: layoutWidth, height: layoutHeight))
        let block = content.getRenderable(environment: environment)
        let size = block.sizeFor(context: context, environment: environment, proposedSize: layoutRect.size).max
        let renderRect = CGRect(origin: layoutRect.origin, size: size)
        block.render(context: context, environment: environment, rect: renderRect)
    }

    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(pageInfo: pageInfo)[keyPath: keypath]
    }
}
