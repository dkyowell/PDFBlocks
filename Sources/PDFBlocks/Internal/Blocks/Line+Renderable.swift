/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
#if os(macOS)
    import AppKit
#endif
#if os(iOS)
    import UIKit
#endif

extension Line: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposal: Proposal) -> BlockSize {
        BlockSize(min: .zero, max: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let path = CGMutablePath()
        let startPoint = CGPoint(x: rect.minX + rect.width * start.x,
                                 y: rect.minY + rect.height * start.y)
        let endPoint = CGPoint(x: rect.minX + rect.width * end.x,
                               y: rect.minY + rect.height * end.y)
        path.addLines(between: [startPoint, endPoint])
        context.renderer.renderLine(environment: environment, path: path)
        return nil
    }
}
