/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

#if os(macOS) || os(iOS)
    import Foundation

    #if os(macOS)
        import AppKit
        import CoreText

        public typealias KitFont = NSFont
        public typealias KitFontDescriptor = NSFontDescriptor
        public typealias KitColor = NSColor
        public typealias KitImage = NSImage
    #endif

    #if os(iOS)
        import CoreText
        import UIKit

        public typealias KitFont = UIFont
        public typealias KitFontDescriptor = UIFontDescriptor
        public typealias KitColor = UIColor
        public typealias KitImage = UIImage
    #endif

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
            // OLD CODE BEFORE USING SHAPE STYLE. TO BE DELETED
            // cgContext?.addRect(insetRect)
            // cgContext?.setLineWidth(width)
            // if let color = shapeStyle as? Color {
            //     cgContext?.setStrokeColor(color.cgColor)
            //     cgContext?.drawPath(using: .stroke)
            // } else if let gradient = shapeStyle as? LinearGradient {
            //     cgContext?.replacePathWithStrokedPath()
            //     drawLinearGradient(gradient: gradient, rect: insetRect)
            //     cgContext?.resetClip()
            // } else if let gradient = shapeStyle as? RadialGradient {
            //     cgContext?.replacePathWithStrokedPath()
            //     cgContext?.clip()
            //     drawRadialGradient(gradient: gradient, rect: rect)
            // }
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

        // TODO: sizeForCTText
        func sizeForCTText(_ text: String, environment: EnvironmentValues, proposedSize: Proposal) -> (min: CGSize, max: CGSize) {
            let string = prepareText(text, environment: environment)
            let range = CFRangeMake(0, string.length)
            let ellipsis = prepareText("…", environment: environment)
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

        func prepareText(_ text: String, environment: EnvironmentValues) -> NSMutableAttributedString {
            let string = NSMutableAttributedString(string: text)
            let range = CFRangeMake(0, string.length)
            let resolvedFont: KitFont = environment.font.resolvedFont(environment: environment)
            var ctFont: CTFont = resolvedFont
            var lineHeight = resolvedFont.ascender + abs(resolvedFont.descender) + resolvedFont.leading
            var fontTransform = CGAffineTransformIdentity
                .scaledBy(x: 1, y: -1)
            ctFont = CTFontCreateCopyWithAttributes(ctFont, 0, &fontTransform, nil)
            CFAttributedStringSetAttribute(string, range, kCTFontAttributeName, ctFont)
            CFAttributedStringSetAttribute(string, range, kCTKernAttributeName, NSNumber(floatLiteral: environment.kerning))

            var paragraphSettings: [CTParagraphStyleSetting] = []
            //   LINE BREAK MODE
            let lineBreakMode = CTLineBreakMode.byWordWrapping
            let lineBreakSetting: CTParagraphStyleSetting = withUnsafeBytes(of: lineBreakMode) {
                CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: MemoryLayout<CTLineBreakMode>.size, value: $0.baseAddress!)
            }
            paragraphSettings.append(lineBreakSetting)
            let lineHeightSetting = withUnsafeMutableBytes(of: &lineHeight) {
                CTParagraphStyleSetting(spec: .maximumLineHeight, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!)
            }
            paragraphSettings.append(lineHeightSetting)
            // APPLY PARAGRAPH SETTINS
            let paragraphStyle = CTParagraphStyleCreate(paragraphSettings, paragraphSettings.count)
            CFAttributedStringSetAttribute(string, range, kCTParagraphStyleAttributeName, paragraphStyle)
            // SET ATTRIBUTES
            if let color = environment.foregroundStyle as? Color {
                CFAttributedStringSetAttribute(string, range, kCTForegroundColorAttributeName, color.cgColor)
            }
            if let stroke = environment.textStroke {
                CFAttributedStringSetAttribute(string, range, kCTStrokeColorAttributeName, stroke.color.cgColor)
                CFAttributedStringSetAttribute(string, range, kCTStrokeWidthAttributeName, NSNumber(floatLiteral: stroke.lineWidth))
            }
            if let fill = environment.textFill, let stroke = environment.textStroke {
                CFAttributedStringSetAttribute(string, range, kCTStrokeColorAttributeName, stroke.color.cgColor)
                CFAttributedStringSetAttribute(string, range, kCTStrokeWidthAttributeName, NSNumber(floatLiteral: -stroke.lineWidth))
                CFAttributedStringSetAttribute(string, range, kCTForegroundColorAttributeName, fill.cgColor)
            }
            return string
        }

        func renderCTText(_ text: String, environment: EnvironmentValues, rect: CGRect) -> String {
            guard layer == layerFilter else {
                return ""
            }
            let attributedString = prepareText(text, environment: environment)
            let range = CFRangeMake(0, attributedString.length)
            // SET FONT
            let resolvedFont: KitFont = environment.font.resolvedFont(environment: environment)
            let lineHeight = resolvedFont.ascender + abs(resolvedFont.descender) + resolvedFont.leading
            // DRAW TEXT
            let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
            let frame = CTFramesetterCreateFrame(framesetter, range, CGPath(rect: rect, transform: .none), nil)
            let visibleRange = CTFrameGetVisibleStringRange(frame)
            let truncate = (visibleRange.length < attributedString.length) && !environment.textContinuationMode
            guard let cgContext else {
                fatalError()
            }
            guard let lines = CTFrameGetLines(frame) as? [CTLine] else {
                fatalError()
            }
            for (offset, line) in lines.enumerated() {
                let bounds = CTLineGetBoundsWithOptions(line, [.useOpticalBounds])
                if truncate, offset == lines.count - 1 {
                    let ellipsis = prepareText("…", environment: environment)
                    let ellipsisLine = CTLineCreateWithAttributedString(ellipsis)
                    let ellipsisBounds = CTLineGetBoundsWithOptions(ellipsisLine, [.useOpticalBounds])
                    if bounds.width + ellipsisBounds.width ~<= rect.width {
                        let dx: CGFloat = switch environment.multilineTextAlignment {
                        case .leading:
                            0
                        case .center:
                            (rect.width - bounds.width - ellipsisBounds.width) / 2
                        case .trailing:
                            rect.width - bounds.width - ellipsisBounds.width
                        }
                        cgContext.textPosition = rect.origin.offset(dx: dx, dy: bounds.minY + lineHeight * CGFloat(offset + 1))
                        CTLineDraw(line, cgContext)
                        cgContext.textPosition.x += bounds.width
                        CTLineDraw(ellipsisLine, cgContext)
                    } else {
                        let cfRange = CTLineGetStringRange(line)
                        var nsRange = NSMakeRange(cfRange.location == kCFNotFound ? NSNotFound : cfRange.location, cfRange.length)
                        while nsRange.length > 0 {
                            nsRange = NSRange(location: nsRange.location, length: nsRange.length - 1)
                            let lastLineString = attributedString.attributedSubstring(from: nsRange)
                            let lastLine = CTLineCreateWithAttributedString(lastLineString)
                            let lastLineBounds = CTLineGetBoundsWithOptions(lastLine, [.useOpticalBounds])
                            if lastLineBounds.width + ellipsisBounds.width ~<= rect.width {
                                let dx: CGFloat = switch environment.multilineTextAlignment {
                                case .leading:
                                    0
                                case .center:
                                    (rect.width - lastLineBounds.width - ellipsisBounds.width) / 2
                                case .trailing:
                                    rect.width - lastLineBounds.width - ellipsisBounds.width
                                }
                                cgContext.textPosition = rect.origin.offset(dx: dx, dy: lastLineBounds.minY + lineHeight * CGFloat(offset + 1))

                                CTLineDraw(lastLine, cgContext)
                                cgContext.textPosition.x += lastLineBounds.width
                                CTLineDraw(ellipsisLine, cgContext)
                                break
                            }
                        }
                    }
                } else {
                    let dx: CGFloat = switch environment.multilineTextAlignment {
                    case .leading:
                        0
                    case .center:
                        (rect.width - bounds.width) / 2
                    case .trailing:
                        rect.width - bounds.width
                    }
                    cgContext.textPosition = rect.origin.offset(dx: dx, dy: bounds.minY + lineHeight * CGFloat(offset + 1))
                    CTLineDraw(line, cgContext)
                }
            }
            if environment.textContinuationMode {
                let nsRange = NSMakeRange(visibleRange.location == kCFNotFound ? NSNotFound : visibleRange.location, visibleRange.length)
                attributedString.deleteCharacters(in: nsRange)
                return attributedString.string
            } else {
                return ""
            }
        }
    }
#endif

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
