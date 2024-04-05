/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Line: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        .init(min: .init(width: proposedSize.width, height: thickness.points),
              max: .init(width: proposedSize.width, height: thickness.points))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        context.renderer.renderLine(dash: dash, environment: environment, rect: rect)
    }

    func proportionalWidth(environment _: EnvironmentValues) -> Double? {
        nil
    }
}
