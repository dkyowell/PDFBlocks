/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Columns: Renderable {
    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(allowWrap: allowWrap)[keyPath: keypath]
    }

    func sizeFor(context _: Context, environment _: EnvironmentValues, proposal: Proposal) -> BlockSize {
        BlockSize(proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment
        environment.layoutAxis = .vertical
        if allowWrap {
            // TODO: Can Columns really act as a secondary wrapping block?
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
        } else {
            renderColumns(context: context, environment: environment, rect: rect)
            return nil
        }
    }
}

extension Columns {
    func renderColumns(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.textContinuationMode = true
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
            if allowWrap {
                if blocks.count > 0 {
                    context.endPage()
                    context.beginPage()
                }
            } else {
                return
            }
        }
    }
}
