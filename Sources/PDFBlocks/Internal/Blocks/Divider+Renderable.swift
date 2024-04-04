/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Divider: Renderable {
    func sizeFor(context _: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        switch environment.layoutAxis {
        case .horizontal:
            .init(min: .init(width: size.points, height: proposedSize.height),
                  max: .init(width: size.points, height: proposedSize.height))
        case .vertical:
            .init(min: .init(width: proposedSize.width, height: size.points),
                  max: .init(width: proposedSize.width, height: size.points))
        case .undefined:
            .init(min: .zero, max: .zero)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        context.renderer.renderLine(dash: [], environment: environment, rect: rect)
    }
}
