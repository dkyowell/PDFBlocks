/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct Frame<Content>: Block where Content: Block {
    var width: Size?
    var height: Size?
    var alignment: Alignment = .center
    let content: Content
}

extension Frame: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        var environment = environment
        environment.allowMultipageBlocks = .false("Frame")
        let block = content.getRenderable(environment: environment)
        var adjustedSize = proposedSize
        if let width, width.max == false {
            adjustedSize.width = width.points
        }
        if let height, height.max == false {
            adjustedSize.height = height.points
        }
        let size = block.sizeFor(context: context, environment: environment, proposedSize: adjustedSize)
        let w: CGFloat = if let width {
            width.max ? proposedSize.width : width.points
        } else {
            size.max.width
        }
        let h: CGFloat = if let height {
            height.max ? proposedSize.height : height.points
        } else {
            size.max.height
        }
        return .init(min: .init(width: w, height: h), max: .init(width: w, height: h))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.allowMultipageBlocks = .false("Frame")
        let block = content.getRenderable(environment: environment)
        let size = block.sizeFor(context: context, environment: environment, proposedSize: rect.size)
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
        block.render(context: context, environment: environment, rect: printRect)
    }

    func proportionalWidth(environment _: EnvironmentValues) -> Double? {
        nil
    }
}

struct FrameModifier: BlockModifier {
    let width: Size?
    let height: Size?
    let alignment: Alignment

    func body(content: Content) -> some Block {
        Frame(width: width, height: height, alignment: alignment, content: content)
    }
}
