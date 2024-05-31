/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension EmptyBlock: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposal _: Proposal) -> BlockSize {
        BlockSize(.zero)
    }

    func render(context _: Context, environment _: EnvironmentValues, rect _: CGRect) -> (any Renderable)? {
        nil
    }
}
