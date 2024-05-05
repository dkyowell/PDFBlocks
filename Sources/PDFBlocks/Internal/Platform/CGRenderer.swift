/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import CoreTextSwift
import Foundation

#if os(macOS)
    import AppKit
    import CoreText

    public typealias KitFont = NSFont
    public typealias KitFontDescriptor = NSFontDescriptor
    public typealias KitColor = NSColor
    public typealias KitImage = NSImage
    public typealias KitAttributes = AttributeScopes.AppKitAttributes
    extension NSFont: @unchecked Sendable {}
#endif

#if os(iOS)
    import CoreText
    import UIKit

    public typealias KitFont = UIFont
    public typealias KitFontDescriptor = UIFontDescriptor
    public typealias KitColor = UIColor
    public typealias KitImage = UIImage
    public typealias KitAttributes = AttributeScopes.UIKitAttributes
#endif

extension NSParagraphStyle: @unchecked Sendable {}

// A core graphics based renderer for iOS and macOS.
class CGRenderer: Renderer {
    init() {}

    // The layer allows a page to be rendered in two passes. This is required for handling page wrapping blocks.
    var layer = 1
    var layerFilter = 1
    func setLayer(_ value: Int) {
        layer = value
    }

    func setLayerFilter(_ value: Int) {
        layerFilter = value
    }

    var pageSize: CGSize = .zero
    var pageNo = 0
    func startNewPage(pageSize: CGSize) {
        var mediaBox = CGRect(origin: .zero, size: pageSize)
        cgContext?.beginPage(mediaBox: &mediaBox)
        self.pageSize = pageSize
        cgContext?.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: pageSize.height))
    }

    func endPage() {
        cgContext?.endPDFPage()
        pageNo += 1
    }

    var cgContext: CGContext? = nil

    func render(renderingCallback: () -> Void) throws -> Data? {
        let pdfData = NSMutableData()
        guard let consumer = CGDataConsumer(data: pdfData) else {
            fatalError()
        }
        guard let cgContext = CGContext(consumer: consumer, mediaBox: nil, nil) else {
            fatalError()
        }
        self.cgContext = cgContext
        #if os(macOS)
            let previousContext = NSGraphicsContext.current
            let graphicsContext = NSGraphicsContext(cgContext: cgContext, flipped: true)
            NSGraphicsContext.current = graphicsContext
        #endif
        #if os(iOS)
            UIGraphicsPushContext(cgContext)
        #endif
        renderingCallback()
        cgContext.closePDF()
        #if os(macOS)
            NSGraphicsContext.current = previousContext
        #endif
        #if os(iOS)
            UIGraphicsPopContext()
        #endif
        return pdfData as Data
    }

    func starClipRegion(rect: CGRect) {
        guard layer == layerFilter else {
            return
        }
        cgContext?.clip(to: rect)
    }

    func endClipRegion() {
        guard layer == layerFilter else {
            return
        }
        cgContext?.resetClip()
    }

    func startRotation(angle: CGFloat, anchor: UnitPoint, rect: CGRect) {
        guard layer == layerFilter else {
            return
        }
        cgContext?.saveGState()
        let dx = rect.minX + anchor.x * rect.width
        let dy = rect.minY + anchor.y * rect.height
        cgContext?.concatenate(CGAffineTransform(translationX: dx, y: dy))
        cgContext?.concatenate(CGAffineTransformMakeRotation(angle))
        cgContext?.concatenate(CGAffineTransform(translationX: -dx, y: -dy))
    }

    var opacityStack: [CGFloat] = []
    func startOpacity(opacity: CGFloat) {
        guard layer == layerFilter else {
            return
        }
        opacityStack.append(opacity)
        cgContext?.saveGState()
        cgContext?.setAlpha(opacityStack.reduce(1.0, *))
    }

    func restoreOpacity() {
        guard layer == layerFilter else {
            return
        }
        cgContext?.restoreGState()
        opacityStack = opacityStack.dropLast()
        cgContext?.setAlpha(opacityStack.reduce(1.0, *))
    }

    func startScale(scale: CGSize, anchor: UnitPoint, rect: CGRect) {
        guard layer == layerFilter else {
            return
        }
        cgContext?.saveGState()
        let dx = rect.minX + anchor.x * rect.width
        let dy = rect.minY + anchor.y * rect.height
        cgContext?.concatenate(CGAffineTransform(translationX: dx, y: dy))
        cgContext?.concatenate(CGAffineTransform(scaleX: scale.width, y: scale.height))
        cgContext?.concatenate(CGAffineTransform(translationX: -dx, y: -dy))
    }

    func restoreState() {
        guard layer == layerFilter else {
            return
        }
        cgContext?.restoreGState()
    }

    func startOffset(x: CGFloat, y: CGFloat) {
        guard layer == layerFilter else {
            return
        }
        cgContext?.saveGState()
        cgContext?.concatenate(CGAffineTransform(translationX: x, y: y))
    }

    func drawLinearGradient(gradient: LinearGradient, rect: CGRect) {
        guard let cgGradient = CGGradient(colorsSpace: nil,
                                          colors: gradient.gradient.stops.map(\.color.cgColor) as CFArray,
                                          locations: gradient.gradient.stops.map(\.location))
        else {
            return
        }
        let startX = rect.minX + gradient.startPoint.x * rect.width
        let startY = rect.minY + gradient.startPoint.y * rect.height
        let endX = rect.minX + gradient.endPoint.x * rect.width
        let endY = rect.minY + gradient.endPoint.y * rect.height
        cgContext?.drawLinearGradient(cgGradient,
                                      start: .init(x: startX, y: startY),
                                      end: .init(x: endX, y: endY),
                                      options: [])
    }

    func drawRadialGradient(gradient: RadialGradient, rect: CGRect) {
        guard let cgGradient = CGGradient(colorsSpace: nil,
                                          colors: gradient.gradient.stops.map(\.color.cgColor) as CFArray,
                                          locations: gradient.gradient.stops.map(\.location))
        else {
            return
        }
        let startX = rect.minX + gradient.center.x * rect.width
        let startY = rect.minY + gradient.center.y * rect.height
        cgContext?.drawRadialGradient(cgGradient,
                                      startCenter: .init(x: startX, y: startY),
                                      startRadius: gradient.startRadius.points,
                                      endCenter: .init(x: startX, y: startY),
                                      endRadius: gradient.endRadius.points,
                                      options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
    }

    func renderLine(environment: EnvironmentValues, path: CGPath) {
        guard layer == layerFilter else {
            return
        }
        cgContext?.addPath(path)
        cgContext?.setLineWidth(environment.strokeStyle.lineWidth.points)
        cgContext?.setLineDash(phase: environment.strokeStyle.dashPhase, lengths: environment.strokeStyle.dash)
        cgContext?.setLineCap(environment.strokeStyle.lineCap)
        cgContext?.setLineJoin(environment.strokeStyle.lineJoin)
        cgContext?.setMiterLimit(environment.strokeStyle.miterLimit)
        if let strokeContent = environment.strokeContent as? Color {
            cgContext?.setStrokeColor(strokeContent.cgColor)
            cgContext?.drawPath(using: .stroke)
        } else if let strokeContent = environment.strokeContent as? LinearGradient {
            cgContext?.addPath(path)
            cgContext?.setLineWidth(environment.strokeStyle.lineWidth.points)
            cgContext?.replacePathWithStrokedPath()
            cgContext?.clip()
            // THIS GIVES PREVENTS GRADIENT FROM BEING CLIPPED
            let box = path.copy(strokingWithWidth: environment.strokeStyle.lineWidth.points,
                                lineCap: .square,
                                lineJoin: .miter,
                                miterLimit: 90).boundingBox
            drawLinearGradient(gradient: strokeContent, rect: box)
            cgContext?.resetClip()
        } else if let strokeContent = environment.strokeContent as? RadialGradient {
            cgContext?.addPath(path)
            cgContext?.setLineWidth(environment.strokeStyle.lineWidth.points)
            cgContext?.replacePathWithStrokedPath()
            cgContext?.clip()
            // THIS GIVES PREVENTS GRADIENT FROM BEING CLIPPED
            let box = path.copy(strokingWithWidth: environment.strokeStyle.lineWidth.points,
                                lineCap: .square,
                                lineJoin: .miter,
                                miterLimit: 90).boundingBox
            drawRadialGradient(gradient: strokeContent, rect: box)
            cgContext?.resetClip()
        } else {
            cgContext?.drawPath(using: .stroke)
        }
    }

    func renderPath(environment: EnvironmentValues, path: CGPath) {
        guard layer == layerFilter else {
            return
        }
        if let strokeContent = environment.strokeContent as? Color {
            cgContext?.addPath(path)
            cgContext?.setLineWidth(environment.strokeStyle.lineWidth.points)
            cgContext?.setLineDash(phase: environment.strokeStyle.dashPhase, lengths: environment.strokeStyle.dash)
            cgContext?.setLineCap(environment.strokeStyle.lineCap)
            cgContext?.setLineJoin(environment.strokeStyle.lineJoin)
            cgContext?.setMiterLimit(environment.strokeStyle.miterLimit)
            cgContext?.setStrokeColor(strokeContent.cgColor)
            cgContext?.drawPath(using: .stroke)
        } else if let strokeContent = environment.strokeContent as? LinearGradient {
            cgContext?.addPath(path)
            cgContext?.setLineWidth(environment.strokeStyle.lineWidth.points)
            cgContext?.replacePathWithStrokedPath()
            cgContext?.clip()
            // THIS GIVES PREVENTS GRADIENT FROM BEING CLIPPED
            let box = path.copy(strokingWithWidth: environment.strokeStyle.lineWidth.points,
                                lineCap: .square,
                                lineJoin: .miter,
                                miterLimit: 90).boundingBox
            drawLinearGradient(gradient: strokeContent, rect: box)
            cgContext?.resetClip()
        } else if let strokeContent = environment.strokeContent as? RadialGradient {
            cgContext?.addPath(path)
            cgContext?.setLineWidth(environment.strokeStyle.lineWidth.points)
            cgContext?.replacePathWithStrokedPath()
            cgContext?.clip()
            // THIS GIVES PREVENTS GRADIENT FROM BEING CLIPPED
            let box = path.copy(strokingWithWidth: environment.strokeStyle.lineWidth.points,
                                lineCap: .square,
                                lineJoin: .miter,
                                miterLimit: 90).boundingBox
            drawRadialGradient(gradient: strokeContent, rect: box)
            cgContext?.resetClip()
        }
        if environment.strokeContent == nil || environment.fill != nil {
            let fill = environment.fill ?? environment.foregroundStyle
            if let fill = fill as? Color {
                cgContext?.addPath(path)
                cgContext?.setFillColor(fill.cgColor)
                cgContext?.drawPath(using: .fill)
            } else if let fill = fill as? LinearGradient {
                cgContext?.addPath(path)
                cgContext?.clip()
                drawLinearGradient(gradient: fill, rect: path.boundingBox)
                cgContext?.resetClip()
            } else if let fill = fill as? RadialGradient {
                cgContext?.addPath(path)
                cgContext?.clip()
                drawRadialGradient(gradient: fill, rect: path.boundingBox)
                cgContext?.resetClip()
            }
        }
    }

    func renderBorder(environment: EnvironmentValues, rect: CGRect, shapeStyle: ShapeStyle, width: CGFloat) {
        guard layer == layerFilter else {
            return
        }
        let insetRect = rect.insetBy(dx: width / 2, dy: width / 2)
        let path = CGPath(rect: insetRect, transform: .none)
        let copy = path.copy(strokingWithWidth: width, lineCap: .butt, lineJoin: .miter, miterLimit: 90)
        var environment = environment
        environment.fill = shapeStyle
        renderPath(environment: environment, path: copy)
    }

    func renderImage(_ image: PlatformImage, environment _: EnvironmentValues, rect: CGRect) {
        guard layer == layerFilter else {
            return
        }
        guard let image = image as? KitImage else {
            return
        }
        if let ds = image.downscaled(maxSize: rect.size.scaled(by: 300 / 72.0)) {
            ds.draw(in: rect)
        }
    }

    func prepareString(_ text: AttributedString, environment: EnvironmentValues) -> NSMutableAttributedString {
        var text = text
        let resolvedFont: KitFont = environment.font.resolvedFont(environment: environment)
        var container = AttributeContainer()
        if let stroke = environment.textStroke {
            container[KitAttributes.StrokeColorAttribute.self] = stroke.color.kitColor
            if environment.textFill == nil {
                container[KitAttributes.StrokeWidthAttribute.self] = stroke.lineWidth
            } else {
                container[KitAttributes.StrokeWidthAttribute.self] = -stroke.lineWidth
            }
        }
        let style = NSMutableParagraphStyle()
        let lineHeight = resolvedFont.ascender + abs(resolvedFont.descender) + resolvedFont.leading
        style.maximumLineHeight = lineHeight
        container[KitAttributes.ParagraphStyleAttribute.self] = style
        if let fill = environment.textFill {
            container[KitAttributes.ForegroundColorAttribute.self] = fill.kitColor
        } else if let color = environment.foregroundStyle as? Color {
            container[KitAttributes.ForegroundColorAttribute.self] = color.kitColor
        }
        container[KitAttributes.FontAttribute.self] = resolvedFont
        container[KitAttributes.KernAttribute.self] = environment.kerning
        text.mergeAttributes(container, mergePolicy: .keepCurrent)
        return NSMutableAttributedString(text)
    }

    // TODO: sizeForCTText
    func sizeForText(_ text: AttributedString, environment: EnvironmentValues, proposedSize: Proposal) -> (min: CGSize, max: CGSize) {
        let string = prepareString(text, environment: environment)
        let range = CFRangeMake(0, string.length)
        let ellipsis = prepareString("…", environment: environment)
        let resolvedFont: KitFont = environment.font.resolvedFont(environment: environment)
        let lineHeight = resolvedFont.ascender + abs(resolvedFont.descender) + resolvedFont.leading
        let rect = CGRect(origin: .zero, size: CGSize(width: proposedSize.width, height: max(proposedSize.height, lineHeight)))
        let framesetter = CTFramesetterCreateWithAttributedString(string)
        var fitRange = CFRangeMake(0, 0)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, rect.size, &fitRange)
        if fitRange.length < range.length {
            let frame = CTFramesetterCreateFrame(framesetter, range, CGPath(rect: rect, transform: .none), nil)
            guard let lines = CTFrameGetLines(frame) as? [CTLine], let lastLine = lines.last else {
                return (min: size, max: size)
            }
            let maxWidth = lines.dropLast().map { CTLineGetBoundsWithOptions($0, [.useOpticalBounds]).width }.reduce(0, max)
            let ellipsisLine = CTLineCreateWithAttributedString(ellipsis)
            let ellipsisBounds = CTLineGetBoundsWithOptions(ellipsisLine, [.useOpticalBounds])
            let lastLineBounds = CTLineGetBoundsWithOptions(lastLine, [.useOpticalBounds])
            let newMaxWidth = max(maxWidth, ellipsisBounds.width + lastLineBounds.width)
            let truncatedWidth = min(newMaxWidth, proposedSize.width)
            let truncatedSize = CGSize(width: truncatedWidth, height: size.height)
            return (min: truncatedSize, max: truncatedSize)
        } else {
            return (min: size, max: size)
        }
    }

    func renderText(_ text: AttributedString, environment: EnvironmentValues, rect: CGRect) -> AttributedString {
        guard layer == layerFilter else {
            return ""
        }
        guard let cgContext else {
            fatalError()
        }
        cgContext.saveGState()
        cgContext.scaleBy(x: 1, y: -1)
        cgContext.translateBy(x: 0, y: -pageSize.height)
        let nsAttrString = prepareString(text, environment: environment)
        let framesetter = nsAttrString.framesetter()
        let frame = framesetter.createFrame(rect)
        let visibleRange = frame.visibleStringRange()
        let truncate = (visibleRange.length < nsAttrString.length) && !environment.textContinuationMode
        let lines = frame.lines()
        let origins = frame.lineOrigins()
        let rectOffset = pageSize.height - rect.maxY
        let isGradient = (environment.foregroundStyle is LinearGradient || environment.foregroundStyle is RadialGradient)
        for (offset, line) in lines.enumerated() {
            let lineBounds = CTLineGetBoundsWithOptions(line, [.useOpticalBounds])
            if truncate, offset == lines.count - 1 {
                let ellipsis = prepareString("…", environment: environment)
                let ellipsisLine = ellipsis.line()
                let ellipsisBounds = CTLineGetBoundsWithOptions(ellipsisLine, [.useOpticalBounds])
                if lineBounds.width + ellipsisBounds.width ~<= rect.width {
                    // Case 1: there are more lines
                    var dx: CGFloat = rect.minX
                    switch environment.multilineTextAlignment {
                    case .leading:
                        dx += 0
                    case .center:
                        dx += (rect.width - lineBounds.width - ellipsisBounds.width) / 2
                    case .trailing:
                        dx += rect.width - lineBounds.width - ellipsisBounds.width
                    }
                    let dy = rectOffset + origins[offset].y
                    if isGradient {
                        var transform = CGAffineTransform(translationX: dx, y: dy)
                        line.drawGlyphs(cgContext: cgContext, transform: &transform)
                        transform = transform.translatedBy(x: lineBounds.width, y: 0)
                        ellipsisLine.drawGlyphs(cgContext: cgContext, transform: &transform)
                    } else {
                        cgContext.textPosition = CGPoint(x: dx, y: dy)
                        CTLineDraw(line, cgContext)
                        CTLineDraw(ellipsisLine, cgContext)
                    }

                } else {
                    // Case 2: long line overflows
                    let cfRange = CTLineGetStringRange(line)
                    var nsRange = NSMakeRange(cfRange.location == kCFNotFound ? NSNotFound : cfRange.location, cfRange.length)
                    while nsRange.length > 0 {
                        nsRange = NSRange(location: nsRange.location, length: nsRange.length - 1)
                        let lastLineString = nsAttrString.attributedSubstring(from: nsRange)
                        let lastLine = CTLineCreateWithAttributedString(lastLineString)
                        let lastLineBounds = CTLineGetBoundsWithOptions(lastLine, [.useOpticalBounds])
                        if lastLineBounds.width + ellipsisBounds.width ~<= rect.width {
                            var dx: CGFloat = rect.minX
                            switch environment.multilineTextAlignment {
                            case .leading:
                                dx += 0
                            case .center:
                                dx += (rect.width - lineBounds.width - ellipsisBounds.width) / 2
                            case .trailing:
                                dx += rect.width - lineBounds.width - ellipsisBounds.width
                            }
                            let dy = rectOffset + origins[offset].y
                            if isGradient {
                                var transform = CGAffineTransform(translationX: dx, y: dy)
                                lastLine.drawGlyphs(cgContext: cgContext, transform: &transform)
                                transform = transform.translatedBy(x: lastLineBounds.width, y: 0)
                                ellipsisLine.drawGlyphs(cgContext: cgContext, transform: &transform)
                            } else {
                                cgContext.textPosition = CGPoint(x: dx, y: dy)
                                CTLineDraw(lastLine, cgContext)
                                CTLineDraw(ellipsisLine, cgContext)
                            }
                            break
                        }
                    }
                }
            } else {
                let dx: CGFloat = switch environment.multilineTextAlignment {
                case .leading:
                    0
                case .center:
                    (rect.width - lineBounds.width) / 2
                case .trailing:
                    rect.width - lineBounds.width
                }
                if isGradient {
                    var transform = CGAffineTransform(translationX: rect.minX + dx, y: rectOffset + origins[offset].y)
                    line.drawGlyphs(cgContext: cgContext, transform: &transform)
                } else {
                    let dy = origins[offset].y + pageSize.height - rect.maxY
                    cgContext.textPosition = CGPoint(x: rect.minX + dx, y: dy)
                    CTLineDraw(line, cgContext)
                }
            }
        }
        if let gradient = environment.foregroundStyle as? LinearGradient {
            cgContext.clip()
            drawLinearGradient(gradient: gradient, rect: rect.offsetBy(dx: 0, dy: rectOffset - rect.minY))
            cgContext.resetClip()
        } else if let gradient = environment.foregroundStyle as? RadialGradient {
            cgContext.clip()
            drawRadialGradient(gradient: gradient, rect: rect.offsetBy(dx: 0, dy: rectOffset - rect.minY))
            cgContext.resetClip()
        }
        cgContext.restoreGState()
        if environment.textContinuationMode {
            let nsRange = NSMakeRange(visibleRange.location == kCFNotFound ? NSNotFound : visibleRange.location, visibleRange.length)
            nsAttrString.deleteCharacters(in: nsRange)
            return AttributedString(nsAttrString)
        } else {
            return ""
        }
    }

    func textRemainder(_ text: AttributedString, environment: EnvironmentValues, rect: CGRect) -> AttributedString {
        let nsAttrString = prepareString(text, environment: environment)
        let framesetter = nsAttrString.framesetter()
        let frame = framesetter.createFrame(rect)
        let visibleRange = frame.visibleStringRange()
        let nsRange = NSMakeRange(visibleRange.location == kCFNotFound ? NSNotFound : visibleRange.location, visibleRange.length)
        nsAttrString.deleteCharacters(in: nsRange)
        return AttributedString(nsAttrString)
    }
}

extension CTLine {
    func drawGlyphs(cgContext: CGContext, transform: inout CGAffineTransform) {
        for run in glyphRuns() {
            let positions = run.glyphPositions()
            for (offset, glyph) in run.glyphs().enumerated() {
                let point = positions[offset]
                let font = run.font
                if let glyphPath = font.path(for: glyph) {
                    var transform = CGAffineTransform(translationX: point.x, y: 0)
                        .concatenating(transform)
                    if let translatedGlyph = glyphPath.copy(using: &transform) {
                        cgContext.addPath(translatedGlyph)
                    }
                }
            }
        }
    }
}

extension Color {
    var kitColor: KitColor {
        (platformColor as? KitColor) ?? KitColor.black
    }

    var cgColor: CGColor {
        kitColor.cgColor
    }
}

#if os(macOS)
    extension NSImage {
        // NOTE: NSImage.size does not report pixels. Higher DPI images can report the same "size" as lower DPI images.
        // in order to get the true pixel dimmension, use CGImage.

        var cgImage: CGImage? {
            guard let imageData = tiffRepresentation else {
                return nil
            }
            guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else {
                return nil
            }
            return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
        }

        func downscaled(maxSize: CGSize) -> NSImage? {
            guard let cgImage else {
                return nil
            }
            guard maxSize.width < CGFloat(cgImage.bytesPerRow) else {
                return self
            }
            let options: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: max(maxSize.height, maxSize.width),
            ]
            // guard let imageData = self.JPEGRepresentation(compressionFactor: 0.7) else { return nil }
            guard let imageData = tiffRepresentation else {
                return nil
            }
            guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else {
                return nil
            }
            guard let result = CGImageSourceCreateThumbnailAtIndex(sourceData, 0, options as CFDictionary) else {
                return nil
            }
            let imageResult = NSImage(cgImage: result, size: CGSize(width: result.width, height: result.height))
            return imageResult
        }
    }

#endif

#if os(iOS)
    extension UIImage {
        func downscaled(maxSize: CGSize) -> UIImage? {
            guard maxSize.width < size.width else {
                return self
            }
            UIGraphicsBeginImageContextWithOptions(maxSize, false, 1.0)
            draw(in: CGRect(origin: CGPoint.zero, size: maxSize))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledImage
        }
    }
#endif

extension CFRange {
    init(range: NSRange) {
        self = CFRangeMake(range.location == NSNotFound ? kCFNotFound : range.location, range.length)
    }
}
