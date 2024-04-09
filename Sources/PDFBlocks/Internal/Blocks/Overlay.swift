/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct Overlay<Content, OverlayContent>: Block where Content: Block, OverlayContent: Block {
    let content: Content
    let overlay: OverlayContent
    let alignment: Alignment
}

extension Overlay: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        var environment = environment
        environment.allowMultipageBlocks = .false("Overlay")
        return content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposedSize: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.allowMultipageBlocks = .false("Overlay")
        content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        let block = overlay.getRenderable(environment: environment)
        let size = block.sizeFor(context: context, environment: environment, proposedSize: rect.size)
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

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }
}

struct OverlayModifier<OverlayContent>: BlockModifier where OverlayContent: Block {
    let overlay: OverlayContent
    let alignment: Alignment

    func body(content: Content) -> some Block {
        Overlay(content: content, overlay: overlay, alignment: alignment)
    }
}
