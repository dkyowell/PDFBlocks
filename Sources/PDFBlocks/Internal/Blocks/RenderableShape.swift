/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct RenderableShape: Renderable {
    let shape: any Shape

    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        print(shape.sizeThatFits(proposedSize))
        return BlockSize(min: .zero, max: shape.sizeThatFits(proposedSize))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let zeroOrignRect = CGRect(origin: .zero, size: rect.size)
        let path = shape.path(in: zeroOrignRect).cgPath
        var transform = CGAffineTransform(translationX: rect.minX, y: rect.minY)
        if let offsetPath = path.copy(using: &transform) {
            context.renderer.renderPath(environment: environment, path: offsetPath)
        }
    }
}
