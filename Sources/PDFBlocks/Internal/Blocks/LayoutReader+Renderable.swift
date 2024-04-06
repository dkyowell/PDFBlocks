/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension LayoutReader: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        .init(min: proposedSize, max: proposedSize)
    }

    func render(context _: Context, environment: EnvironmentValues, rect: CGRect) {
        // PageFrame injects a sendLayoutRect function in the environment. LayoutReader calls
        // that function to report its size to the PageFrame.
        environment.sendLayoutRect(rect)
    }
}
