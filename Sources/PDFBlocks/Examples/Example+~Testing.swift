/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// import AppKit

private struct Document: Block {
    var font: KitFont {
        let systemFont = KitFont.systemFont(ofSize: 30, weight: .ultraLight)
//        let font: NSUIFont = if let descriptor = systemFont.fontDescriptor.withDesign(.serif) {
//            NSUIFont(descriptor: descriptor, size: systemFont.pointSize)
//        } else {
//            systemFont
//        }
        return systemFont
    }

    var body: some Block {
        Page(size: .init(width: .in(4), height: .in(6)), margins: .in(1)) {
            VStack(alignment: .center) {
                // Color.cyan.opacity(0.25)
                Text("One Fish")
                    .fontWeight(.ultraLight)
                Text("One Fish")
                    .fontWeight(.thin)
                Text("One Fish")
                    .fontWeight(.light)
                Text("One Fish")
                    .fontWeight(.regular)
                Text("One Fish")
                    .fontWeight(.medium)
                Text("One Fish")
                    .fontWeight(.semibold)
                Text("One Fish")
                    .fontWeight(.heavy)
                Text("One Fish")
                    .fontWeight(.black)
            }
            .fontDesign(.rounded)
            .fontWidth(.condensed)
            .font(size: 24)
            // .border(.orange)
            .font(.system(size: 12))
        }
        .border(.black, width: 4)
    }
}

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
        print("\n>>>")
        let view = PDFView()
        view.autoScales = true
        Task {
            if let data = try? await Document()
                .renderPDF(size: .letter, margins: .init(.in(1)))
            {
                view.document = PDFDocument(data: data)
            }
        }
        return view
    }
#endif
