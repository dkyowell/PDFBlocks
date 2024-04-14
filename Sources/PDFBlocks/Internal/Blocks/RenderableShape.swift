/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct RenderableShape: Renderable {
    let shape: any Shape

    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        let zeroOrignRect = CGRect(origin: .zero, size: proposedSize)
        let path = shape.path(in: zeroOrignRect).cgPath
        return BlockSize(min: .zero, max: path.boundingBoxOfPath.size)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        // In SwiftUI, Shape.path(in rect: CGRect) -> Path always receives a .zero orgin CGRect
        let zeroOrignRect = CGRect(origin: .zero, size: rect.size)
        let path = shape.path(in: zeroOrignRect).cgPath

        var transform = CGAffineTransform(translationX: rect.minX, y: rect.minY)
        if let offsetPath = path.copy(using: &transform) {
            context.renderer.renderPath(environment: environment, path: offsetPath)
        }
    }
}
