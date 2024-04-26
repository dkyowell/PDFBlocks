/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import CoreGraphics
import Foundation

// A protocol that allows for different PDF rendering libraries to be used.
protocol Renderer {
    func setLayer(_ value: Int)
    func setLayerFilter(_ value: Int)
    func starClipRegion(rect: CGRect)
    func endClipRegion()
    func render(renderingCallback: () -> Void) throws -> Data?
    func startNewPage(pageSize: CGSize)
    func endPage()
    func startOffset(x: CGFloat, y: CGFloat)
    func startScale(scale: CGSize, anchor: UnitPoint, rect: CGRect)
    func startRotation(angle: CGFloat, anchor: UnitPoint, rect: CGRect)
    func startOpacity(opacity: CGFloat)
    func restoreOpacity()
    func restoreState()
    func renderBorder(environment: EnvironmentValues, rect: CGRect, shapeStyle: ShapeStyle, width: CGFloat)
    func renderLine(dash: [CGFloat], environment: EnvironmentValues, rect: CGRect)
    func renderPath(environment: EnvironmentValues, path: CGPath)
    func renderImage(_ image: PlatformImage, environment: EnvironmentValues, rect: CGRect)
    func renderCTText(_ text: String, environment: EnvironmentValues, rect: CGRect) -> String
    func sizeForCTText(_ text: String, environment: EnvironmentValues, proposedSize: CGSize) -> (min: CGSize, max: CGSize)
}
