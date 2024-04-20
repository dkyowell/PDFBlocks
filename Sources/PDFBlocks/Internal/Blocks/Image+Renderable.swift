/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import AVFoundation
import Foundation

// TODO: Implement AVMakeRect without AVFoundation.

extension Image: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: proposal))
        return .init(min: rect.size, max: rect.size)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        context.renderer.renderImage(image, environment: environment, rect: rect)
        return nil
    }
}
