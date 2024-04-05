/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func proportionalFrame(width: CGFloat = 1, alignment: HorizontalAlignment = .leading) -> some Block {
        ProporionalFrame(width: width, alignment: alignment, content: self)
    }
}

struct ProporionalFrame<Content>: Block where Content: Block {
    var width: Double
    let alignment: HorizontalAlignment
    let content: Content
}

extension ProporionalFrame: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let width = content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposedSize: rect.size).max.width
        let dx: CGFloat = switch alignment {
        case .leading:
            0
        case .center:
            (rect.width - width) / 2
        case .trailing:
            rect.width - width
        }
        let renderRect = CGRect(x: rect.minX + dx, y: rect.minY, width: width, height: rect.height)
        content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: renderRect)
    }

    func proportionalWidth(environment _: EnvironmentValues) -> Double? {
        width
    }
}

extension Background {}
