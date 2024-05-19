/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import AVFoundation
import Foundation

extension Image: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: proposal))
        return .init(min: .zero, max: rect.size)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: rect.origin, size: rect.size))
        context.renderer.renderImage(image, environment: environment, rect: rect)
        return nil
    }
}
