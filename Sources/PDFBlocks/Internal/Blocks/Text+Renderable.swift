/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Text: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let result = context.renderer.sizeForCTText(value, environment: environment, proposedSize: proposal)
        return BlockSize(min: result.min, max: result.max)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let remainder = context.renderer.renderCTText(value, environment: environment, rect: rect)
        if remainder.count > 0 {
            return Text(remainder)
        } else {
            return nil
        }
    }
}

extension Text {
    func decompose(context: Context, environment: EnvironmentValues, proposal: Proposal) -> [any Renderable] {
        context.renderer.decomposeText(value, environment: environment, proposedSize: proposal)
            .map { Text($0) }
    }
}

extension VStack {
//    func decompose(context: Context, environment: EnvironmentValues, proposal: Proposal) -> [any Renderable] {
//        print("IS THIS CALLED")
    ////        content.
    ////        return [self]
//    //func decompose(context: Context, environment: EnvironmentValues, proposal: Proposal) -> [any Renderable] {
    ////        print("IS THIS CALLED")
    ////        return context.renderer.decomposeText(value, environment: environment, proposedSize: proposal)
    ////            .map({Text($0)})
//    }
}
