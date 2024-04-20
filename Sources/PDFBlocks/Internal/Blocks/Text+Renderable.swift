/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Text: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let result = context.renderer.sizeForText(format.format(input), environment: environment, proposedSize: proposal)
        return .init(min: result.min, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        context.renderer.renderText(format.format(input), environment: environment, rect: rect)
        return nil
    }
}

extension CTText: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let result = context.renderer.sizeForCTText(input, environment: environment, proposedSize: proposal)
        // print("result", proposedSize, input, result)
        return BlockSize(min: .zero, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
//        context.renderer.renderText(input, environment: environment, rect: rect)
//        return nil
        let remainder = context.renderer.renderCTText(input, environment: environment, rect: rect)
        if remainder.count > 0 {
            return CTText(remainder)
        } else {
            return nil
        }
    }
}

public struct Columns<Content>: Block where Content: Block {
    let count: Int
    let spacing: Dimension
    let atomic: Bool
    let content: Content

    public init(count: Int, spacing: Dimension, atomic: Bool = true, @BlockBuilder content: () -> Content) {
        self.count = max(1, count)
        self.spacing = spacing
        self.atomic = atomic
        self.content = content()
    }
}

extension Columns: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposal: Proposal) -> BlockSize {
        BlockSize(proposal)
    }

    func renderColumns(context: Context, environment: EnvironmentValues, rect: CGRect) {
        guard context.renderer.layer == context.renderer.renderLayer else {
            return
        }
        let columnWidth = (rect.width - CGFloat(count - 1) * spacing.points) / CGFloat(count)
        var blocks = content.getRenderables(environment: environment)
        while blocks.count > 0 {
            for column in 0 ..< count {
                let xPos = rect.minX + (columnWidth + spacing.points) * CGFloat(column)
                var dy: CGFloat = 0
                while rect.minY + dy < rect.maxY, blocks.isEmpty == false {
                    guard let block = blocks.first else {
                        break
                    }
                    blocks = blocks.dropFirst().map { $0 }
                    let remainingSize = CGSize(width: columnWidth, height: rect.height - dy)
                    let size = block.sizeFor(context: context, environment: environment, proposal: remainingSize)
                    if rect.minY + dy + size.min.height < rect.maxY {
                        let renderRect = CGRect(x: xPos, y: rect.minY + dy, width: columnWidth, height: size.max.height)
                        let remainder = block.render(context: context, environment: environment, rect: renderRect)
                        dy += renderRect.height
                        if let remainder {
                            blocks.insert(remainder, at: 0)
                            break
                        }
                    } else {
                        blocks.insert(block, at: 0)
                        break
                    }
                }
            }
            if atomic {
                return
            } else {
                if blocks.count > 0 {
                    context.endPage()
                    context.beginPage()
                }
            }
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.layoutAxis = .vertical
        if atomic {
            renderColumns(context: context, environment: environment, rect: rect)
            return nil
        } else {
            if environment.renderMode == .wrapping {
                // This is a secondary page wrapping block
                renderColumns(context: context, environment: environment, rect: rect)
                return nil
            } else {
                // This is a primary page wrapping block
                context.renderer.setLayer(2)
                guard context.multiPagePass == nil else {
                    return nil
                }
                context.multiPagePass = {
                    environment.renderMode = .wrapping
                    renderColumns(context: context, environment: environment, rect: rect)
                }
                return nil
            }
        }
    }
}
