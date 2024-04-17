/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

#if os(macOS) || os(iOS)

    import Foundation

    #if os(macOS)
        import AppKit

        public typealias NSUIFont = NSFont
        public typealias NSUIColor = NSColor
        public typealias NSUIImage = NSImage
    #endif

    #if os(iOS)
        import UIKit

        public typealias NSUIFont = UIFont
        public typealias NSUIColor = UIColor
        public typealias NSUIImage = UIImage
    #endif

    // A core graphics based renderer for iOS and macOS.
    class CGRenderer: Renderer {
        init() {}

        // The layer allows a page to be rendered in two passes. This is required for handling page wrapping blocks.
        var layer = 1
        var renderLayer = 1
        func setLayer(_ value: Int) {
            layer = value
        }

        func setRenderLayer(_ value: Int) {
            renderLayer = value
        }

        func startNewPage(pageSize: CGSize) {
            var mediaBox = CGRect(origin: .zero, size: pageSize)
            cgContext?.beginPage(mediaBox: &mediaBox)
            cgContext?.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: pageSize.height))
        }

        func endPage() {
            cgContext?.endPDFPage()
        }

        var cgContext: CGContext? = nil

//        #if os(iOS)
//            func render(renderingCallback: () -> Void) throws -> Data? {
//                let renderer = UIGraphicsPDFRenderer()
//                let pdfData = renderer.pdfData { rendererContext in
//                    self.pdfContext = rendererContext
//                    self.cgContext = rendererContext.cgContext
//                    renderingCallback()
//                }
//                return pdfData
//            }
//        #endif

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

        func startRotation(angle: CGFloat, anchor: UnitPoint, rect: CGRect) {
            guard layer == renderLayer else {
                return
            }
            cgContext?.saveGState()
            let dx = rect.minX + anchor.x * rect.width
            let dy = rect.minY + anchor.y * rect.height
            cgContext?.concatenate(CGAffineTransform(translationX: dx, y: dy))
            cgContext?.concatenate(CGAffineTransformMakeRotation(angle))
            cgContext?.concatenate(CGAffineTransform(translationX: -dx, y: -dy))
        }

        func restoreState() {
            guard layer == renderLayer else {
                return
            }
            cgContext?.restoreGState()
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

        func renderPath(environment: EnvironmentValues, path: CGPath) {
            guard layer == renderLayer else {
                return
            }
            cgContext?.saveGState()
            cgContext?.setAlpha(environment.opacity)
            if let strokeContent = environment.strokeContent as? Color {
                cgContext?.addPath(path)
                cgContext?.setLineWidth(environment.strokeLineWidth.points)
                cgContext?.setStrokeColor(strokeContent.cgColor)
                cgContext?.drawPath(using: .stroke)
            } else if let strokeContent = environment.strokeContent as? LinearGradient {
                cgContext?.addPath(path)
                cgContext?.setLineWidth(environment.strokeLineWidth.points)
                cgContext?.replacePathWithStrokedPath()
                cgContext?.clip()
                // THIS GIVES PREVENTS GRADIENT FROM BEING CLIPPED
                let box = path.copy(strokingWithWidth: environment.strokeLineWidth.points,
                                    lineCap: .square,
                                    lineJoin: .miter,
                                    miterLimit: 90).boundingBox
                drawLinearGradient(gradient: strokeContent, rect: box)
                cgContext?.resetClip()
            } else if let strokeContent = environment.strokeContent as? RadialGradient {
                cgContext?.addPath(path)
                cgContext?.setLineWidth(environment.strokeLineWidth.points)
                cgContext?.replacePathWithStrokedPath()
                cgContext?.clip()
                // THIS GIVES PREVENTS GRADIENT FROM BEING CLIPPED
                let box = path.copy(strokingWithWidth: environment.strokeLineWidth.points,
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
            cgContext?.restoreGState()
        }

        func renderBorder(environment: EnvironmentValues, rect: CGRect, shapeStyle: ShapeStyle, width: CGFloat) {
            guard layer == renderLayer else {
                return
            }
            let insetRect = rect.insetBy(dx: width / 2, dy: width / 2)
            let path = CGPath(rect: insetRect, transform: .none)
            let copy = path.copy(strokingWithWidth: width, lineCap: .butt, lineJoin: .miter, miterLimit: 90)
            var environment = environment
            environment.fill = shapeStyle
            renderPath(environment: environment, path: copy)
            // OLD CODE BEFORE USING SHAPE STYLE. TO BE DELETED
            // cgContext?.saveGState()
            // cgContext?.setAlpha(environment.opacity)
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
            // cgContext?.restoreGState()
        }

        func renderLine(dash: [CGFloat], environment: EnvironmentValues, rect: CGRect) {
            guard layer == renderLayer else {
                return
            }
            cgContext?.saveGState()
            cgContext?.setAlpha(environment.opacity)
            cgContext?.addLines(between: [
                .init(x: rect.minX, y: rect.midY),
                .init(x: rect.maxX, y: rect.midY),
            ])
            cgContext?.setLineDash(phase: 0, lengths: dash)
            if environment.layoutAxis == .vertical {
                cgContext?.setLineWidth(rect.height)
            } else {
                cgContext?.setLineWidth(rect.width)
            }
            let color = (environment.foregroundStyle as? Color) ?? Color.black
            cgContext?.setStrokeColor(color.cgColor)
            cgContext?.drawPath(using: .stroke)
            cgContext?.restoreGState()
        }

        func renderImage(_ image: PlatformImage, environment: EnvironmentValues, rect: CGRect) {
            cgContext?.saveGState()
            cgContext?.setAlpha(environment.opacity)
            guard let image = image as? NSUIImage else {
                return
            }
            if let ds = image.downscaled(maxSize: rect.size.scaled(by: 300 / 72.0)) {
                ds.draw(in: rect)
            }
            cgContext?.restoreGState()
        }

        func sizeForText(_ text: String, environment: EnvironmentValues, proposedSize: ProposedSize) -> (min: CGSize, max: CGSize) {
            let string = NSString(string: text)
            var attributes = [NSAttributedString.Key: Any]()
            let fontName = environment.fontName
            let fontSize = environment.fontSize
            let font: NSUIFont
            font = NSUIFont(name: fontName.value, size: fontSize) ?? .systemFont(ofSize: fontSize)
            attributes[.font] = font
            if environment.bold {
                #if os(macOS)
                    if let boldFontName = environment.boldFontName?.value {
                        attributes[.font] = NSFont(name: boldFontName, size: font.pointSize)
                    } else {
                        let descriptor = font.fontDescriptor.withSymbolicTraits(.bold)
                        attributes[.font] = NSFont(descriptor: descriptor, size: font.pointSize)
                    }
                #else
                    if let boldFontName = environment.boldFontName?.value {
                        attributes[.font] = UIFont(name: boldFontName, size: font.pointSize)
                    } else {
                        if let descriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) {
                            attributes[.font] = UIFont(descriptor: descriptor, size: font.pointSize)
                        }
                    }
                #endif
            }
            if environment.italic {
                #if os(macOS)
                    let descriptor = font.fontDescriptor.withSymbolicTraits(.italic)
                    attributes[.font] = NSFont(descriptor: descriptor, size: font.pointSize)
                #else
                    if let descriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic) {
                        attributes[.font] = UIFont(descriptor: descriptor, size: font.pointSize)
                    }
                #endif
            }
            let paragraphStyle = NSMutableParagraphStyle()
            switch environment.multilineTextAlignment {
            case .leading:
                paragraphStyle.alignment = .left
            case .center:
                paragraphStyle.alignment = .center
            case .trailing:
                paragraphStyle.alignment = .right
            case .justified:
                paragraphStyle.alignment = .justified
            }
            switch environment.truncationMode {
            case .head:
                paragraphStyle.lineBreakMode = .byTruncatingHead
            case .middle:
                paragraphStyle.lineBreakMode = .byTruncatingMiddle
            case .tail:
                paragraphStyle.lineBreakMode = .byTruncatingTail
            case .wrap:
                paragraphStyle.lineBreakMode = .byWordWrapping
            }
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            #if os(macOS)
                var options: NSString.DrawingOptions = [.usesLineFragmentOrigin]
            #else
                var options: NSStringDrawingOptions = [.usesLineFragmentOrigin]
            #endif
            if environment.truncationMode == .wrap {
                options.insert(.truncatesLastVisibleLine)
            }
            let rect = string.boundingRect(with: .init(width: proposedSize.width, height: 0),
                                           options: options,
                                           attributes: attributes,
                                           context: nil)

            return (min: .init(width: min(rect.width, proposedSize.width), height: min(rect.height, proposedSize.height)),
                    max: .init(width: min(rect.width, proposedSize.width), height: min(rect.height, proposedSize.height)))
        }

        func renderText(_ text: String, environment: EnvironmentValues, rect: CGRect) {
            guard layer == renderLayer else {
                return
            }
            cgContext?.saveGState()
            cgContext?.setAlpha(environment.opacity)
            let string = NSString(string: text)
            var attributes = [NSAttributedString.Key: Any]()
            let fontName = environment.fontName
            let fontSize = environment.fontSize
            let font: NSUIFont
            font = NSUIFont(name: fontName.value, size: fontSize) ?? .systemFont(ofSize: fontSize)
            attributes[.font] = font
            if environment.bold {
                #if os(macOS)
                    if let boldFontName = environment.boldFontName?.value {
                        attributes[.font] = NSFont(name: boldFontName, size: font.pointSize)
                    } else {
                        let descriptor = font.fontDescriptor.withSymbolicTraits(.bold)
                        attributes[.font] = NSFont(descriptor: descriptor, size: font.pointSize)
                    }
                #else
                    if let boldFontName = environment.boldFontName?.value {
                        attributes[.font] = UIFont(name: boldFontName, size: font.pointSize)
                    } else {
                        if let descriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) {
                            attributes[.font] = UIFont(descriptor: descriptor, size: font.pointSize)
                        }
                    }
                #endif
            }
            if environment.italic {
                #if os(macOS)
                    let descriptor = font.fontDescriptor.withSymbolicTraits(.italic)
                    attributes[.font] = NSFont(descriptor: descriptor, size: font.pointSize)
                #else
                    if let descriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic) {
                        attributes[.font] = UIFont(descriptor: descriptor, size: font.pointSize)
                    }
                #endif
            }
            let paragraphStyle = NSMutableParagraphStyle()
            switch environment.multilineTextAlignment {
            case .leading:
                paragraphStyle.alignment = .left
            case .center:
                paragraphStyle.alignment = .center
            case .trailing:
                paragraphStyle.alignment = .right
            case .justified:
                paragraphStyle.alignment = .justified
            }
            switch environment.truncationMode {
            case .head:
                paragraphStyle.lineBreakMode = .byTruncatingHead
            case .middle:
                paragraphStyle.lineBreakMode = .byTruncatingMiddle
            case .tail:
                paragraphStyle.lineBreakMode = .byTruncatingTail
            case .wrap:
                paragraphStyle.lineBreakMode = .byWordWrapping
            }
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            #if os(macOS)
                var options: NSString.DrawingOptions = [.usesLineFragmentOrigin]
            #else
                var options: NSStringDrawingOptions = [.usesLineFragmentOrigin]
            #endif
            if environment.truncationMode == .wrap {
                options.insert(.truncatesLastVisibleLine)
            }
            //  It seems that some rounding errors are causing the last line to truncate, so give it just a hair
            //  more room.
            let newRect = CGRect(origin: rect.origin, size: .init(width: rect.width, height: rect.height + 0.000001))
            if let stroke = environment.textStroke {
                if let color = environment.textFill {
                    cgContext?.setTextDrawingMode(.fillStroke)
                    cgContext?.setLineWidth(stroke.lineWidth.points)
                    cgContext?.setStrokeColor(stroke.color.cgColor)
                    attributes[.strokeColor] = stroke.color
                    attributes[.foregroundColor] = color.cgColor
                    string.draw(with: newRect, options: options, attributes: attributes, context: nil)
                } else {
                    cgContext?.setTextDrawingMode(.stroke)
                    cgContext?.setLineWidth(stroke.lineWidth.points)
                    cgContext?.setStrokeColor(stroke.color.cgColor)
                    attributes[.strokeColor] = stroke.color
                    string.draw(with: newRect, options: options, attributes: attributes, context: nil)
                }
            } else {
                if let color = environment.foregroundStyle as? Color {
                    attributes[.foregroundColor] = color.nsuiColor
                    string.draw(with: newRect, options: options, attributes: attributes, context: nil)
                } else if let _ = environment.foregroundStyle as? LinearGradient {
                    attributes[.foregroundColor] = Color.black.nsuiColor
                    string.draw(with: newRect, options: options, attributes: attributes, context: nil)
                    // DISABLED BECAUSE THE GRADIENT WOULD SOMETIMES WORK BUT RANDOMLY FILL THE SCREEN WHEN RENDERED
                    // IN COMBINATION WITH OTHER ELEMENTS IN A STACK.
                    // cgContext?.setTextDrawingMode(.clip)
                    // string.draw(with: newRect, options: options, attributes: attributes, context: nil)
                    // drawLinearGradient(gradient: gradient, rect: newRect)
                } else if let _ = environment.foregroundStyle as? RadialGradient {
                    attributes[.foregroundColor] = Color.black.nsuiColor
                    string.draw(with: newRect, options: options, attributes: attributes, context: nil)
                    // DISABLED BECAUSE THE GRADIENT WOULD SOMETIMES WORK BUT RANDOMLY FILL THE SCREEN WHEN RENDERED
                    // IN COMBINATION WITH OTHER ELEMENTS IN A STACK.
                    // cgContext?.setTextDrawingMode(.clip)
                    // string.draw(with: newRect, options: options, attributes: attributes, context: nil)
                    // drawRadialGradient(gradient: gradient, rect: newRect)
                }
            }
            cgContext?.restoreGState()
        }
    }
#endif

extension Color {
    var nsuiColor: NSUIColor {
        (platformColor as? NSUIColor) ?? NSUIColor.black
    }

    var cgColor: CGColor {
        nsuiColor.cgColor
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
