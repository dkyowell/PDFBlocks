/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct Frame<Content>: Block where Content: Block {
    var width: Dimension?
    var height: Dimension?
    var alignment: Alignment = .center
    let content: Content
}

extension Frame: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        // TODO: Stop any search for proportionalWidth?
        if keypath == \.proprtionalWidth {
            Trait(proprtionalWidth: nil)[keyPath: keypath]
        } else {
            content.getRenderable(environment: environment)
                .getTrait(context: context, environment: environment, keypath: keypath)
        }
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let renderable = content.getRenderable(environment: environment)
//        if renderable.isSecondaryPageWrapBlock(context: context, environment: environment) {
//            return renderable.sizeFor(context: context, environment: environment, proposal: proposal)
//        } else {
        var adjustedSize = proposal
        if let width, width.max == false {
            adjustedSize.width = width.points
        }
        if let height, height.max == false {
            adjustedSize.height = height.points
        }
        let size = renderable.sizeFor(context: context, environment: environment, proposal: adjustedSize)
        let w: CGFloat = if let width {
            width.max ? proposal.width : width.points
        } else {
            size.max.width
        }
        let h: CGFloat = if let height {
            height.max ? proposal.height : height.points
        } else {
            size.max.height
        }
        return .init(min: .init(width: w, height: h), max: .init(width: w, height: h))
//        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let renderable = content.getRenderable(environment: environment)
//        if renderable.isSecondaryPageWrapBlock(context: context, environment: environment) {
//            renderable.render(context: context, environment: environment, rect: rect)
//            return nil
//        } else {
        let size = renderable.sizeFor(context: context, environment: environment, proposal: rect.size)
        let dx: CGFloat = switch alignment.horizontalAlignment {
        case .leading:
            0
        case .center:
            (rect.width - size.max.width) / 2.0
        case .trailing:
            rect.width - size.max.width
        }
        let dy: CGFloat = switch alignment.verticalAlignment {
        case .top:
            0
        case .center:
            (rect.height - size.max.height) / 2.0
        case .bottom:
            rect.height - size.max.height
        }
        let printRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size.max)
        let remainder = renderable.render(context: context, environment: environment, rect: printRect)
        if let content = remainder as? AnyBlock {
            return Frame<AnyBlock>(width: width, height: height, alignment: alignment, content: content)
        } else {
            return nil
        }
//        }
    }
}

struct FrameModifier: BlockModifier {
    let width: Dimension?
    let height: Dimension?
    let alignment: Alignment

    func body(content: Content) -> some Block {
        Frame(width: width, height: height, alignment: alignment, content: content)
    }
}
