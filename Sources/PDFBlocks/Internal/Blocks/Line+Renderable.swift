/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Line: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposal: Proposal) -> BlockSize {
        .init(min: .init(width: proposal.width, height: thickness.points),
              max: .init(width: proposal.width, height: thickness.points))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        context.renderer.renderLine(dash: dash, environment: environment, rect: rect)
        return nil
    }
}
