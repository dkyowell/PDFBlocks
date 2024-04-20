/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension TableContentSpacer: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposal: Proposal) -> BlockSize {
        BlockSize(proposal)
    }

    func render(context: Context, environment _: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        context.setPageWrapRect(rect)
        return nil
    }
}
