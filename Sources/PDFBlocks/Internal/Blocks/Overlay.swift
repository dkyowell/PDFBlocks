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
    func decompose(context: Context, environment: EnvironmentValues, proposal: Proposal) -> [any Renderable] {
        content.getRenderable(environment: environment)
            .decompose(context: context, environment: environment, proposal: proposal)
    }

    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content.getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let renderable = overlay.getRenderable(environment: environment)
        let remainder = content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        let size = renderable.sizeFor(context: context, environment: environment, proposal: rect.size)
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
        renderable.render(context: context, environment: environment, rect: renderRect)
        if let content = remainder as? AnyBlock {
            return Overlay<AnyBlock, OverlayContent>(content: content, overlay: overlay, alignment: alignment)
        } else {
            return nil
        }
    }
}

struct OverlayModifier<OverlayContent>: BlockModifier where OverlayContent: Block {
    let overlay: OverlayContent
    let alignment: Alignment

    func body(content: Content) -> some Block {
        Overlay(content: content, overlay: overlay, alignment: alignment)
    }
}
