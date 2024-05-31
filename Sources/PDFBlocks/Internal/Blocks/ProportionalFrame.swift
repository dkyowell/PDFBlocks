/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct ProporionalFrame<Content>: Block where Content: Block {
    var width: Double
    let horizontalAlignment: HorizontalAlignment
    let content: Content
}

extension ProporionalFrame: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        if keypath == \.proprtionalWidth {
            Trait(proprtionalWidth: width)[keyPath: keypath]
        } else {
            content.getRenderable(environment: environment)
                .getTrait(context: context, environment: environment, keypath: keypath)
        }
    }

    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        content.getRenderable(environment: environment)
            .remainder(context: context, environment: environment, size: size)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let block = content.getRenderable(environment: environment)
        if block.isSecondaryPageWrapBlock(context: context, environment: environment) {
            return block.render(context: context, environment: environment, rect: rect)
        } else {
            let size = block.sizeFor(context: context, environment: environment, proposal: rect.size).max
            let dx: CGFloat = switch horizontalAlignment {
            case .leading:
                0
            case .center:
                (rect.width - size.width) / 2
            case .trailing:
                rect.width - size.width
            }
            let renderRect = CGRect(x: rect.minX + dx, y: rect.minY, width: size.width, height: rect.height)
            return block.render(context: context, environment: environment, rect: renderRect)
        }
    }
}
