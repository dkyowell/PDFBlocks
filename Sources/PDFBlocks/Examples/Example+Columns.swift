/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            CTText(text)
                .frame(width: .in(4), height: .in(2))
                .padding(4)
                .border(.black)
                .font(size: 14)
        }
    }
}

private let text = "They're Pinky and the Brain, Pinky and the Brain. One is a genious. The other's insane. They're labratory mice. They're genes have been spliced. They're Pinky, they're Pink and the Brain Brain Brain Brain."

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
