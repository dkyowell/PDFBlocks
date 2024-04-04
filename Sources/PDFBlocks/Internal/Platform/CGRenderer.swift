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

        private var hasStartedPage = false

        func startNewPage(pageSize: CGSize) {
            #if os(macOS)
                if hasStartedPage {
                    cgContext?.endPDFPage()
                }
                var mediaBox = CGRect(origin: .zero, size: pageSize)
                cgContext?.beginPage(mediaBox: &mediaBox)
                cgContext?.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: pageSize.height))
                hasStartedPage = true
            #else
                let mediaBox = CGRect(origin: .zero, size: pageSize)
                pdfContext?.beginPage(withBounds: mediaBox, pageInfo: [:])
            #endif
        }

        #if os(iOS)
            var pdfContext: UIGraphicsPDFRendererContext?
        #endif
        var cgContext: CGContext? = nil

        #if os(iOS)
            func render(renderingCallback: () -> Void) throws -> Data? {
                let renderer = UIGraphicsPDFRenderer()
                let pdfData = renderer.pdfData { rendererContext in
                    self.pdfContext = rendererContext
                    self.cgContext = rendererContext.cgContext
                    renderingCallback()
                }
                return pdfData
            }
        #endif

        #if os(macOS)
            func render(renderingCallback: () -> Void) throws -> Data? {
                let pdfData = NSMutableData()
                guard let consumer = CGDataConsumer(data: pdfData) else {
                    fatalError()
                }
                guard let cgContext = CGContext(consumer: consumer, mediaBox: nil, nil) else {
                    fatalError()
                }
                self.cgContext = cgContext
                let previousContext = NSGraphicsContext.current
                let graphicsContext = NSGraphicsContext(cgContext: cgContext, flipped: true)
                NSGraphicsContext.current = graphicsContext
                renderingCallback()
                cgContext.endPDFPage()
                cgContext.closePDF()
                NSGraphicsContext.current = previousContext
                return pdfData as Data
            }
        #endif

        func renderColor(_ color: Color, environment: EnvironmentValues, rect: CGRect) {
            let opacity = environment.opacity
            if let cgContext {
                cgContext.addRect(rect)
                #if os(macOS)
                    if let nsColor = color.platformColor as? NSColor {
                        cgContext.setFillColor(nsColor.withAlphaComponent(opacity).cgColor)
                    }
                #else
                    if let uiColor = color.platformColor as? UIColor {
                        cgContext.setFillColor(uiColor.withAlphaComponent(opacity).cgColor)
                    }
                #endif
                cgContext.drawPath(using: .fill)
            }
        }

        func renderBorder(environment _: EnvironmentValues, rect: CGRect, color: Color, width: CGFloat) {
            if let color = color.platformColor as? NSUIColor {
                cgContext?.addRect(rect)
                cgContext?.setLineWidth(width)
                cgContext?.setFillColor(color.cgColor)
                cgContext?.setStrokeColor(color.cgColor)
                cgContext?.drawPath(using: .stroke)
            }
        }

        func renderHDivider(environment _: EnvironmentValues, rect: CGRect) {
            cgContext?.addLines(between: [
                .init(x: rect.minX, y: rect.midY),
                .init(x: rect.maxX, y: rect.midY),
            ])
            cgContext?.setLineWidth(0.75)
            cgContext?.setStrokeColor(NSUIColor.black.cgColor)
            cgContext?.drawPath(using: .stroke)
        }

        func renderHLine(dash: [CGFloat], environment _: EnvironmentValues, rect: CGRect) {
            cgContext?.addLines(between: [
                .init(x: rect.minX, y: rect.midY),
                .init(x: rect.maxX, y: rect.midY),
            ])
            cgContext?.setLineDash(phase: 0, lengths: dash)
            cgContext?.setLineWidth(rect.height)
            cgContext?.setStrokeColor(NSUIColor.black.cgColor)
            cgContext?.drawPath(using: .stroke)
        }

        func renderImage(_ image: PlatformImage, environment _: EnvironmentValues, rect: CGRect) {
            guard let image = image as? NSUIImage else {
                return
            }
            if let ds = image.downscaled(maxSize: rect.size.scaled(by: 300 / 72.0)) {
                ds.draw(in: rect)
            }
        }

        func sizeForText(_ text: String, environment: EnvironmentValues, proposedSize: ProposedSize) -> (min: CGSize, max: CGSize) {
            let string = NSString(string: text)
            var attributes = [NSAttributedString.Key: Any]()
            let fontName = environment.fontName
            let fontSize = environment.fontSize
            let font: NSUIFont
            font = NSUIFont(name: fontName.value, size: fontSize) ?? .systemFont(ofSize: fontSize)
            attributes[.font] = font
            if environment.emphasized {
                #if os(macOS)
                    if let emphasizedFontName = environment.emphasizedFontName?.value {
                        attributes[.font] = NSFont(name: emphasizedFontName, size: font.pointSize)
                    } else {
                        let descriptor = font.fontDescriptor.withSymbolicTraits(.bold)
                        attributes[.font] = NSFont(descriptor: descriptor, size: font.pointSize)
                    }
                #else
                    if let emphasizedFontName = environment.emphasizedFontName?.value {
                        attributes[.font] = UIFont(name: emphasizedFontName, size: font.pointSize)
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
                var options: NSStringDrawingOptions  = [.usesLineFragmentOrigin]
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
            let string = NSString(string: text)
            var attributes = [NSAttributedString.Key: Any]()
            let fontName = environment.fontName
            let fontSize = environment.fontSize
            let font: NSUIFont
            font = NSUIFont(name: fontName.value, size: fontSize) ?? .systemFont(ofSize: fontSize)
            attributes[.font] = font
            if environment.emphasized {
                #if os(macOS)
                    if let emphasizedFontName = environment.emphasizedFontName?.value {
                        attributes[.font] = NSFont(name: emphasizedFontName, size: font.pointSize)
                    } else {
                        let descriptor = font.fontDescriptor.withSymbolicTraits(.bold)
                        attributes[.font] = NSFont(descriptor: descriptor, size: font.pointSize)
                    }
                #else
                    if let emphasizedFontName = environment.emphasizedFontName?.value {
                        attributes[.font] = UIFont(name: emphasizedFontName, size: font.pointSize)
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
                var options: NSStringDrawingOptions  = [.usesLineFragmentOrigin]
            #endif
            if environment.truncationMode == .wrap {
                options.insert(.truncatesLastVisibleLine)
            }

            //  It seems that some rounding errors are causing the last line to truncate, so give it just a hair
            //  more room.
            let newRect = CGRect(origin: rect.origin, size: .init(width: rect.width, height: rect.height + 0.000001))

            if let color = environment.foregroundColor.nsuiColor {
                attributes[.foregroundColor] = color.withAlphaComponent(environment.opacity)
            }

            string.draw(with: newRect, options: options, attributes: attributes, context: nil)
        }
    }
#endif

extension Color {
    var nsuiColor: NSUIColor? {
        platformColor as? NSUIColor
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
