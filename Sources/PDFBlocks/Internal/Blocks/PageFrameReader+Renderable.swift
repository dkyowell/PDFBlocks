/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension PageFrameReader: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        BlockSize(proposedSize)
    }

    func render(context: Context, environment _: EnvironmentValues, rect: CGRect) {
        context.multipageRect = rect
    }
}
