/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Text: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        let result = context.renderer.sizeForText(format.format(input), environment: environment, proposedSize: proposedSize)
        return .init(min: result.min, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        context.renderer.renderText(format.format(input), environment: environment, rect: rect)
    }
}

extension CTText: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        BlockSize(proposedSize)
//        let result = context.renderer.sizeForCTText(format.format(input), environment: environment, proposedSize: proposedSize)
//        return .init(min: result.min, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        let columnWidth = (rect.width - 24) / 2
        let left = CGRect(origin: rect.origin, size: .init(width: columnWidth, height: rect.height))
        let right = CGRect(origin: rect.origin, size: .init(width: columnWidth, height: rect.height))
            .offsetBy(dx: columnWidth + 24, dy: 0)
        let r = context.renderer.renderCTText(format.format(input), environment: environment, rect: left)
        _ = context.renderer.renderCTText(r, environment: environment, rect: right)
    }
}

public struct Columns<Content>: Block where Content: Block {
    let count: Int
    let spacing: Dimension
    let content: Content

    public init(count: Int, spacing: Dimension, @BlockBuilder content: () -> Content) {
        self.count = max(1, count)
        self.spacing = spacing
        self.content = content()
    }
}

extension Columns: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        BlockSize(proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        guard context.renderer.layer == context.renderer.renderLayer else {
            return
        }
        let columnWidth = (rect.width - CGFloat(count) * spacing.points) / CGFloat(count)
        print(count, rect.width, columnWidth, count)
        var blocks = content.getRenderables(environment: environment)
        for column in 0 ... count {
            print("column", column)
            let xPos = rect.minX + (columnWidth + spacing.points) * CGFloat(column)
            print(xPos)
            var dy: CGFloat = 0
            while rect.minY + dy < rect.maxY {
                guard let block = blocks.first else {
                    break
                }
                blocks = blocks.dropFirst().map { $0 }
                let remainingSize = CGSize(width: columnWidth, height: rect.height - dy)
                let size = block.sizeFor(context: context, environment: environment, proposedSize: remainingSize)
                if rect.minY + dy + size.min.height < rect.maxY {
                    let renderRect = CGRect(x: xPos, y: rect.minY + dy, width: columnWidth, height: size.max.height)
                    block.render(context: context, environment: environment, rect: renderRect)
                    dy += renderRect.height
                } else {
                    dy = .infinity
                    blocks.insert(block, at: 0)
                    break
                }
                
            }
        }
    }
}
