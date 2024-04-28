/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// TODO: Add layout priority support. In SwiftUI, spacer gets a lower priority than Color.
extension Spacer: Renderable {
    func sizeFor(context _: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        switch environment.layoutAxis {
        case .vertical:
            switch value {
            case let .fixed(length):
                BlockSize(min: .init(width: 0, height: length.points),
                          max: .init(width: 0, height: length.points))
            case let .min(length):
                BlockSize(min: .init(width: 0, height: length.points),
                          max: .init(width: 0, height: proposal.height))
            }
        case .horizontal:
            switch value {
            case let .fixed(length):
                BlockSize(min: .init(width: length.points, height: 0),
                          max: .init(width: length.points, height: 0))
            case let .min(length):
                BlockSize(min: .init(width: length.points, height: 0),
                          max: .init(width: proposal.width, height: 0))
            }
        case .undefined:
            BlockSize(width: 0, height: 0)
        }
    }

    func render(context _: Context, environment _: EnvironmentValues, rect _: CGRect) -> (any Renderable)? {
        nil
    }
}
