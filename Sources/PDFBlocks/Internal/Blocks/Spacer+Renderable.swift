/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// TODO: Add layout priority support. In SwiftUI, spacer gets a lower priority than Color.
extension Spacer: Renderable {
    func sizeFor(context _: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        switch environment.layoutAxis {
        case .vertical:
            BlockSize(min: .init(width: 0, height: minLength.points),
                      max: .init(width: 0, height: proposedSize.height))
        case .horizontal:
            BlockSize(min: .init(width: minLength.points, height: 0),
                      max: .init(width: proposedSize.width, height: 0))
        case .undefined:
            BlockSize(width: 0, height: 0)
        }
    }

    func render(context _: Context, environment _: EnvironmentValues, rect _: CGRect) {}
}
