/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension FixedSpace: Renderable {
    func sizeFor(context _: Context, environment: EnvironmentValues, proposedSize _: ProposedSize) -> BlockSize {
        switch environment.layoutAxis {
        case .vertical:
            BlockSize(minMax: .init(width: 0, height: size.points))
        case .horizontal:
            BlockSize(minMax: .init(width: size.points, height: 0))
        case .undefined:
            BlockSize(minMax: .zero)
        }
    }

    func render(context _: Context, environment _: EnvironmentValues, rect _: CGRect) {}
}
