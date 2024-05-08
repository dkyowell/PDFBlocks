/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension ZStack: Renderable {
    // TODO: Review minSize
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let blocks = content.getRenderables(environment: environment)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: proposal) }
        let minWidth = sizes.map(\.min.width).reduce(0, max)
        let minHeight = sizes.map(\.min.height).reduce(0, max)
        let maxWidth = sizes.map(\.max.width).reduce(0, max)
        let maxHeight = sizes.map(\.max.height).reduce(0, max)
        return .init(min: .init(width: minWidth, height: minHeight),
                     max: .init(width: maxWidth, height: maxHeight))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        for block in content.getRenderables(environment: environment) {
            let size = block.sizeFor(context: context, environment: environment, proposal: rect.size)
            let dx: CGFloat =
                switch alignment.horizontalAlignment {
                case .leading:
                    0
                case .center:
                    (rect.width - size.max.width) / 2.0
                case .trailing:
                    rect.width - size.max.width
                }
            let dy: CGFloat =
                switch alignment.verticalAlignment {
                case .top:
                    0
                case .center:
                    (rect.height - size.max.height) / 2.0
                case .bottom:
                    rect.height - size.max.height
                }
            let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size.max)
            block.render(context: context, environment: environment, rect: renderRect)
        }
        return nil
    }
}
