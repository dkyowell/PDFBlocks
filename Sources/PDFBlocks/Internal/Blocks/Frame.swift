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

    // TODO: This does not work.
    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        let block = content.getRenderable(environment: environment)
        let frameSize = CGSize(width: width?.points ?? size.width, height: height?.points ?? size.height)
        if let remainder = block.remainder(context: context, environment: environment, size: frameSize) {
            return Frame<AnyBlock>(width: width, height: height, alignment: alignment, content: AnyBlock(remainder))
        } else {
            return nil
        }
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let renderable = content.getRenderable(environment: environment)
        let frameSize = CGSize(width: width?.points ?? proposal.width, height: height?.points ?? proposal.height)
        let size = renderable.sizeFor(context: context, environment: environment, proposal: frameSize)
        let minWidth: CGFloat = width?.points ?? size.min.width
        let minHeight: CGFloat = height?.points ?? size.min.height
        let maxWidth: CGFloat = if let width {
            width.max ? proposal.width : width.points
        } else {
            size.max.width
        }
        let maxHeight: CGFloat = if let height {
            height.max ? proposal.height : height.points
        } else {
            size.max.height
        }
        return BlockSize(min: CGSize(width: minWidth, height: minHeight),
                         max: CGSize(width: maxWidth, height: maxHeight))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let renderable = content.getRenderable(environment: environment)
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
