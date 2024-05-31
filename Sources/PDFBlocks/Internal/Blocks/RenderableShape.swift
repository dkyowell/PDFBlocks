/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct RenderableShape: Renderable {
    let shape: any Shape

    func sizeFor(context _: Context, environment _: EnvironmentValues, proposal: Proposal) -> BlockSize {
        BlockSize(min: .zero, max: shape.sizeThatFits(proposal))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let zeroOrignRect = CGRect(origin: .zero, size: rect.size)
        let path = shape.path(in: zeroOrignRect).cgPath
        var transform = CGAffineTransform(translationX: rect.minX, y: rect.minY)
        if let offsetPath = path.copy(using: &transform) {
            context.renderer.renderPath(environment: environment, path: offsetPath)
        }
        return nil
    }
}
