/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Divider: Renderable {
    func sizeFor(context _: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        if environment.layoutAxis == .horizontal {
            BlockSize(width: size.points + padding.points * 2, height: proposedSize.height)
        } else {
            BlockSize(width: proposedSize.width, height: size.points + padding.points * 2)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        if environment.layoutAxis == .horizontal {
            let rect = CGRect(x: rect.minX + padding.points, y: rect.minY, width: rect.width - padding.points * 2, height: rect.height)
            context.renderer.renderLine(dash: [], environment: environment, rect: rect)
        } else {
            let rect = CGRect(x: rect.minX, y: rect.minY + padding.points, width: rect.width, height: rect.height - padding.points * 2)
            context.renderer.renderLine(dash: [], environment: environment, rect: rect)
        }
    }
}
