/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension FixedSpace: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize _: ProposedSize) -> BlockSize {
        switch direction {
        case .width:
            BlockSize(min: .init(width: length.points, height: 0),
                      max: .init(width: length.points, height: 0))
        case .height:
            BlockSize(min: .init(width: 0, height: length.points),
                      max: .init(width: 0, height: length.points))
        }
    }

    func render(context _: Context, environment _: EnvironmentValues, rect _: CGRect) {}
}
