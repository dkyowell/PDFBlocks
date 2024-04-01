/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Page: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize _: ProposedSize) -> BlockSize {
        let width = size.width.points
        let height = size.height.points
        return .init(min: .init(width: width, height: height),
                     max: .init(width: width, height: height))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let layoutWidth = rect.width - margins.leading.points - margins.trailing.points
        let layoutHeight = rect.height - margins.top.points - margins.bottom.points
        let layoutRect = CGRect(origin: .init(x: margins.leading.points, y: margins.top.points),
                                size: .init(width: layoutWidth, height: layoutHeight))
        let pageSize = CGSize(width: size.width.points, height: size.height.points)
        context.startNewPage(newPageSize: pageSize)
        let block = content.getRenderable(environment: environment)
        let size = block.sizeFor(context: context, environment: environment, proposedSize: layoutRect.size)
        let renderRect = CGRect(origin: layoutRect.origin, size: size.max)
        block.render(context: context, environment: environment, rect: renderRect)
    }
}
