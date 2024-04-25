/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */
let lhm = 0.96
#if os(macOS) || os(iOS)

    import Foundation

    #if os(macOS)
        import AppKit
        import CoreText

        public typealias NSUIFont = NSFont
        public typealias NSUIColor = NSColor
        public typealias NSUIImage = NSImage
    #endif

    #if os(iOS)
        import CoreText
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

        func renderPath(environment: EnvironmentValues, path: CGPath) {
            guard layer == layerFilter else {
                return
            }
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

        func renderLine(dash: [CGFloat], environment: EnvironmentValues, rect: CGRect) {
            guard layer == layerFilter else {
                return
            }
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
        }

        func renderImage(_ image: PlatformImage, environment _: EnvironmentValues, rect: CGRect) {
            guard layer == layerFilter else {
                return
            }
            guard let image = image as? NSUIImage else {
                return
            }
            if let ds = image.downscaled(maxSize: rect.size.scaled(by: 300 / 72.0)) {
                ds.draw(in: rect)
            }
        }

        func sizeForText(_ text: String, environment: EnvironmentValues, proposedSize: Proposal) -> (min: CGSize, max: CGSize) {
            let string = NSString(string: text)
            var attributes = [NSAttributedString.Key: Any]()
            let fontName = environment.fontName
            let fontSize = environment.fontSize
            var font = NSUIFont(name: fontName.value, size: fontSize) ?? .systemFont(ofSize: fontSize)
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
                            font = UIFont(descriptor: descriptor, size: font.pointSize)
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
                    font = UIFont(descriptor: descriptor, size: font.pointSize)
                }
                #endif
            }
            attributes[.font] = font

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

            return (min: rect.size, max: rect.size)
        }

        // TODO: sizeForCTText
        func sizeForCTText(_ text: String, environment: EnvironmentValues, proposedSize: Proposal) -> (min: CGSize, max: CGSize) {
            let rect = CGRect(origin: .zero, size: proposedSize)
            let string = NSMutableAttributedString(string: text)
            let range = CFRangeMake(0, string.length)
            var font = CTFontCreateWithName(environment.fontName.value as CFString, environment.fontSize, .none)
            if environment.bold {
                font = CTFontCreateCopyWithSymbolicTraits(font, 0, .none, CTFontSymbolicTraits.traitBold,
                                                   CTFontSymbolicTraits.traitBold) ?? font
            }
            if environment.italic {
                font = CTFontCreateCopyWithSymbolicTraits(font, 0, .none, CTFontSymbolicTraits.traitItalic,
                                                          CTFontSymbolicTraits.traitItalic) ?? font
            }
            CFAttributedStringSetAttribute(string, range, kCTFontAttributeName, font)
            if environment.multilineTextAlignment == .justified {
                CFAttributedStringSetAttribute(string, range, kCTTrackingAttributeName, NSNumber(floatLiteral: -1) as CFNumber)
            }
            var paragraphSettings: [CTParagraphStyleSetting] = []
            //   ALIGNMENT
            let alignment: CTTextAlignment
            switch environment.multilineTextAlignment {
            case .leading:
                alignment = .left
            case .center:
                alignment = .center
            case .trailing:
                alignment = .right
            case .justified:
                alignment = .justified
            }
            let allignmentSetting: CTParagraphStyleSetting = withUnsafeBytes(of: alignment) {
                CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout<CTTextAlignment>.size, value: $0.baseAddress!)
            }
            paragraphSettings.append(allignmentSetting)

            //   LINE BREAK MODE
            let lineBreakMode = CTLineBreakMode.byWordWrapping
            let lineBreakSetting: CTParagraphStyleSetting = withUnsafeBytes(of: lineBreakMode) {
                CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: MemoryLayout<CTLineBreakMode>.size, value: $0.baseAddress!)
            }
            paragraphSettings.append(lineBreakSetting)

            var lineHeight = 0.0
            if let platformFont = NSUIFont(name: environment.fontName.value, size: environment.fontSize) {
                // NOTE: This is not the same as CTFontGetAscent, CTFontGetDescent, CTFontGetLeading for all typefaces
                lineHeight = platformFont.ascender + abs(platformFont.descender) + platformFont.leading
                let paragraphSetting = withUnsafeMutableBytes(of: &lineHeight) {
                    CTParagraphStyleSetting(spec: .maximumLineHeight, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!)
                }
                paragraphSettings.append(paragraphSetting)
            }

            let paragraphStyle = CTParagraphStyleCreate(paragraphSettings, paragraphSettings.count)
            CFAttributedStringSetAttribute(string, range, kCTParagraphStyleAttributeName as CFString, paragraphStyle)

            // Get size
            // Adjust rect to be at least one line high
            let adjRect = CGRect(origin: rect.origin, size: .init(width: rect.width, height: max(rect.height, lineHeight)))
            let framesetter = CTFramesetterCreateWithAttributedString(string)
            let frame = CTFramesetterCreateFrame(framesetter, range, CGPath(rect: adjRect, transform: .none), nil)
            if let lines = CTFrameGetLines(frame) as? [CTLine] {
                let bounds: [CGRect] = lines.map { line in
                    CTLineGetBoundsWithOptions(line, [])
                }
                let height = lineHeight * CGFloat(lines.count)
                let width = bounds.map((\.width)).reduce(0, max)
                let size = CGSize(width: width, height: height)
                print(size)

                
                return (min: size, max: size)
            } else {
                // Fallback, but this should not be run.
                // This seems to give almost identical results to above, but with the height rounded (up?) to the nearest point.
                let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, rect.size, nil)
                return (min: size, max: size)
            }
        }

        // TODO: renderCTText
        func renderCTText(_ text: String, environment: EnvironmentValues, rect: CGRect) -> String {
            guard layer == layerFilter else {
                return ""
            }
            let string = NSMutableAttributedString(string: text)
            let range = CFRangeMake(0, string.length)
            // SET FONT
            var fontTransform = CGAffineTransformIdentity
                .scaledBy(x: 1, y: -1)
            var font = CTFontCreateWithName(environment.fontName.value as CFString, environment.fontSize, &fontTransform)
            if environment.bold {
                font = CTFontCreateCopyWithSymbolicTraits(font, 0, .none,
                                                   CTFontSymbolicTraits.traitBold,
                                                   CTFontSymbolicTraits.traitBold) ?? font
            }
            if environment.italic {
                font = CTFontCreateCopyWithSymbolicTraits(font, 0, .none, CTFontSymbolicTraits.traitItalic,
                                                          CTFontSymbolicTraits.traitItalic) ?? font
            }
            CFAttributedStringSetAttribute(string, range, kCTFontAttributeName, font)
            // SET PARAGRAPH SETTINGS
            //   ALIGNMENT
            if environment.multilineTextAlignment == .justified {
                CFAttributedStringSetAttribute(string, range, kCTKernAttributeName, NSNumber(floatLiteral: -1) as CFNumber)
            }
            var paragraphSettings: [CTParagraphStyleSetting] = []
            let alignment: CTTextAlignment
            switch environment.multilineTextAlignment {
            case .leading:
                alignment = .left
            case .center:
                alignment = .center
            case .trailing:
                alignment = .right
            case .justified:
                alignment = .justified
            }
            let allignmentSetting: CTParagraphStyleSetting = withUnsafeBytes(of: alignment) {
                CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout<CTTextAlignment>.size, value: $0.baseAddress!)
            }
            paragraphSettings.append(allignmentSetting)
            //   LINE BREAK MODE
            let lineBreakMode = CTLineBreakMode.byWordWrapping
            let lineBreakSetting: CTParagraphStyleSetting = withUnsafeBytes(of: lineBreakMode) {
                CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: MemoryLayout<CTLineBreakMode>.size, value: $0.baseAddress!)
            }
            paragraphSettings.append(lineBreakSetting)
            //   LINE HEIGHT
            var lineHeight = 0.0
            if let platformFont = NSUIFont(name: environment.fontName.value, size: environment.fontSize) {
                // NOTE: This is not the same as CTFontGetAscent, CTFontGetDescent, CTFontGetLeading for all typefaces
                lineHeight = platformFont.ascender + abs(platformFont.descender) + platformFont.leading
                let lineHeightSetting = withUnsafeMutableBytes(of: &lineHeight) {
                    CTParagraphStyleSetting(spec: .maximumLineHeight, valueSize: MemoryLayout<CGFloat>.size, value: $0.baseAddress!)
                }
                paragraphSettings.append(lineHeightSetting)
            }
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

            // DRAW TEXT
            let framesetter = CTFramesetterCreateWithAttributedString(string)
            
            let adjRect = CGRect(origin: rect.origin, size: .init(width: rect.width, height: max(rect.height, lineHeight)))
            
            let frame = CTFramesetterCreateFrame(framesetter, range, CGPath(rect: adjRect, transform: .none), nil)
            if let cgContext {
                
                if let lines = CTFrameGetLines(frame) as? [CTLine] {
                    for (offset, line) in lines.enumerated() {
                        let bounds = CTLineGetBoundsWithOptions(line, [.useOpticalBounds])
                        switch environment.multilineTextAlignment {
                        case .leading:
                            cgContext.textPosition = rect.origin
                                .offset(dy: bounds.minY + lineHeight * CGFloat(offset + 1))
                        case .center:
                            let dx = (rect.width - bounds.width) / 2
                            cgContext.textPosition = rect.origin
                                .offset(dx: dx, dy: bounds.minY + lineHeight * CGFloat(offset + 1))
                        case .trailing:
                            let dx = (rect.width - bounds.width)
                            cgContext.textPosition = rect.origin
                                .offset(dx: dx, dy: bounds.minY + lineHeight * CGFloat(offset + 1))
                        case .justified:
                            cgContext.textPosition = rect.origin
                                .offset(dy: bounds.minY + lineHeight * CGFloat(offset + 1))
                        }
                        CTLineDraw(line, cgContext)
                    }
                }
            }
            
            let drawnRange = CTFrameGetVisibleStringRange(frame)
            let nsRange = NSMakeRange(drawnRange.location == kCFNotFound ? NSNotFound : drawnRange.location, drawnRange.length)
            string.deleteCharacters(in: nsRange)
            return string.string
        }

        func renderText(_ text: String, environment: EnvironmentValues, rect: CGRect) {
            guard layer == layerFilter else {
                return
            }
            let string = NSString(string: text)
            var attributes = [NSAttributedString.Key: Any]()
            let fontName = environment.fontName
            let fontSize = environment.fontSize
            var font = NSUIFont(name: fontName.value, size: fontSize) ?? .systemFont(ofSize: fontSize)
            attributes[.font] = font
            #if os(macOS)
            var traits: NSFontDescriptor.SymbolicTraits = []
            #else
            var traits: UIFontDescriptor.SymbolicTraits = []
            #endif
            if environment.bold {
                #if os(macOS)
                    if let boldFontName = environment.boldFontName?.value {
                        attributes[.font] = NSFont(name: boldFontName, size: font.pointSize)
                    } else {
                        traits.insert(.bold)
                    }
                #else
                    if let boldFontName = environment.boldFontName?.value {
                        attributes[.font] = UIFont(name: boldFontName, size: font.pointSize)
                    } else {
                        traits.insert(.traitBold)
                    }
                #endif
            }
            if environment.italic {
                #if os(macOS)
                traits.insert(.italic)
                #else
                traits.insert(.traitItalic)
                #endif
            }
            #if os(macOS)
            let descriptor = font.fontDescriptor.withSymbolicTraits(traits)
            attributes[.font] = NSFont(descriptor: descriptor, size: font.pointSize)
            #else
                if let descriptor = font.fontDescriptor.withSymbolicTraits(traits) {
                    attributes[.font] = UIFont(descriptor: descriptor, size: font.pointSize)
                }
            #endif
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
                    cgContext?.setLineWidth(stroke.lineWidth)
                    cgContext?.setStrokeColor(stroke.color.cgColor)
                    attributes[.strokeColor] = stroke.color
                    attributes[.foregroundColor] = color.cgColor
                    string.draw(with: newRect, options: options, attributes: attributes, context: nil)
                } else {
                    cgContext?.setTextDrawingMode(.stroke)
                    cgContext?.setLineWidth(stroke.lineWidth)
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
