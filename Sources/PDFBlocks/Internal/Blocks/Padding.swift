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

extension Padding: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        let block = content.getRenderable(environment: environment)
        return block.getTrait(context: context, environment: environment, keypath: keypath)
    }

    // This is called by ModifiedContent which takes care of re-wrapping it in Padding.
    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        let paddingWidth = padding.leading.points + padding.trailing.points
        let paddingHeight = padding.top.points + padding.bottom.points
        let insetWidth = max(0, size.width - paddingWidth)
        let insetHeight = max(0, size.height - paddingHeight)
        let insetSize = CGSize(width: insetWidth, height: insetHeight)
        return content.getRenderable(environment: environment)
            .remainder(context: context, environment: environment, size: insetSize)
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let block = content.getRenderable(environment: environment)
        let paddingWidth = padding.leading.points + padding.trailing.points
        let paddingHeight = padding.top.points + padding.bottom.points
        let insetWidth = max(0, proposal.width - paddingWidth)
        let insetHeight = max(0, proposal.height - paddingHeight)
        let insetProposal = CGSize(width: insetWidth, height: insetHeight)
        let size = block.sizeFor(context: context, environment: environment, proposal: insetProposal)
        let minSize = CGSize(width: size.min.width + paddingWidth, height: size.min.height + paddingHeight)
        let maxWidth = (padding.leading.max || padding.trailing.max) ? proposal.width : (size.max.width + paddingWidth)
        let maxHeight = (padding.top.max || padding.bottom.max) ? proposal.height : (size.max.height + paddingHeight)
        let maxSize = CGSize(width: maxWidth, height: maxHeight)
        return BlockSize(min: minSize, max: maxSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let block = content.getRenderable(environment: environment)
        let paddingWidth = padding.leading.points + padding.trailing.points
        let paddingHeight = padding.top.points + padding.bottom.points
        let insetWidth = max(0, rect.width - paddingWidth)
        let insetHeight = max(0, rect.height - paddingHeight)
        let insetProposal = CGSize(width: insetWidth, height: insetHeight)
        let size = block.sizeFor(context: context, environment: environment, proposal: insetProposal)
        let dx: CGFloat = if padding.leading.max, padding.trailing.max {
            (rect.width - size.max.width) / 2
        } else if padding.leading.max {
            (rect.width - size.max.width) - padding.trailing.points
        } else {
            padding.leading.points
        }
        let dy: CGFloat = if padding.top.max, padding.bottom.max {
            (rect.height - size.max.height) / 2
        } else if padding.top.max {
            (rect.height - size.max.height) - padding.bottom.points
        } else {
            padding.top.points
        }
        let rect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size.max)
        return block.render(context: context, environment: environment, rect: rect)
    }
}

struct PaddingModifier: BlockModifier {
    let padding: EdgeInsets

    func body(content: Content) -> some Block {
        Padding(padding: padding, content: content)
    }
}
