/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension HDivider: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        let points: CGFloat = if let size {
            size.points
        } else {
            2
        }
        return .init(min: .init(width: proposedSize.width, height: points),
                     max: .init(width: proposedSize.width, height: points))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        context.renderer.renderHDivider(environment: environment, rect: rect)
    }
}
