/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension EmptyBlock: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize _: ProposedSize) -> BlockSize {
        .init(min: .zero, max: .zero)
    }

    func render(context _: Context, environment _: EnvironmentValues, rect _: CGRect) {}

    func proportionalWidth(environment _: EnvironmentValues) -> Double? {
        nil
    }
}
