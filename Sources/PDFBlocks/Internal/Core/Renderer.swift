/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// A protocol that allows for different PDF rendering libraries to be used.
protocol Renderer {
    func render(renderingCallback: () -> Void) throws -> Data?
    func startNewPage(pageSize: CGSize)

    func renderColor(_ color: Color, environment: EnvironmentValues, rect: CGRect)
    func renderBorder(environment: EnvironmentValues, rect: CGRect, color: Color, width: CGFloat)
    func renderHDivider(environment: EnvironmentValues, rect: CGRect)
    func renderHLine(dash: [CGFloat], environment: EnvironmentValues, rect: CGRect)
    func renderImage(_ image: PlatformImage, environment: EnvironmentValues, rect: CGRect)
    func renderText(_ text: String, environment: EnvironmentValues, rect: CGRect)
    func sizeForText(_ text: String, environment: EnvironmentValues, proposedSize: CGSize) -> (min: CGSize, max: CGSize)
}
