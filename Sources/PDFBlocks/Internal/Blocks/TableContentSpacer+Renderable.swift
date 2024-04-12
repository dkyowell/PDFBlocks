/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension TableContentSpacer: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        BlockSize(proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        context.beginMultipageRendering(environment: environment, rect: rect)
    }
}
