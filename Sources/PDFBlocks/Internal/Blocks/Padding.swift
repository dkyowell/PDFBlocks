/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct Padding<Content>: Block where Content: Block {
    let padding: EdgeInsets
    let content: Content

    init(padding: EdgeInsets, content: Content) {
        self.padding = padding
        self.content = content
    }
}

// TODO: Fix issue with padding on flexible sized blocks with fixed aspect ratios.
extension Padding: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        content.getRenderable(environment: environment)
            .getTrait(context: context, environment: environment, keypath: keypath)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let block = content.getRenderable(environment: environment)
        let size = block.sizeFor(context: context, environment: environment, proposal: proposal)
        // 1. Determine min
        let minWidth = size.min.width + padding.leading.points + padding.trailing.points
        let minHeight = size.min.height + padding.top.points + padding.bottom.points
        let minSize = CGSize(width: minWidth, height: minHeight)
        // 2. Determine max
        let maxWidth = (padding.leading.max || padding.trailing.max) ? proposal.width :
            min(proposal.width, padding.leading.points + padding.trailing.points + size.max.width)
        let maxHeight = (padding.top.max || padding.bottom.max) ? proposal.height :
            min(proposal.height, padding.top.points + padding.bottom.points + size.max.height)
        let maxSize = CGSize(width: maxWidth, height: maxHeight)
        return .init(min: minSize, max: maxSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let block = content.getRenderable(environment: environment)
        // atomic render
        let paddingWidth = padding.leading.points + padding.trailing.points
        let paddingHeight = padding.top.points + padding.bottom.points
        let proposedSize = CGSize(width: max(0.0, rect.width - paddingWidth), height: max(0.0, rect.height - paddingHeight))
        let contentSize = block.sizeFor(context: context, environment: environment, proposal: proposedSize)
        //  Offset the origin of the rect to adjust to the padding
        let dx: CGFloat = if padding.leading.max, padding.trailing.max {
            (rect.width - contentSize.max.width) / 2
        } else if padding.leading.max {
            (rect.width - contentSize.max.width) - padding.trailing.points
        } else {
            padding.leading.points
        }
        let dy: CGFloat = if padding.top.max, padding.bottom.max {
            (rect.height - contentSize.max.height) / 2
        } else if padding.top.max {
            (rect.height - contentSize.max.height) - padding.bottom.points
        } else {
            padding.top.points
        }
        let rect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: contentSize.max)
        let remainder = block.render(context: context, environment: environment, rect: rect)
        if let content = remainder as? AnyBlock {
            return Padding<AnyBlock>(padding: padding, content: content)
        } else {
            return nil
        }
    }
}

struct PaddingModifier: BlockModifier {
    let padding: EdgeInsets

    func body(content: Content) -> some Block {
        Padding(padding: padding, content: content)
    }
}
