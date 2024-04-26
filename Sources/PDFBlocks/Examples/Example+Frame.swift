/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    let text = "The quick brown fox jumped over the lazy dog."
    var body: some Block {
        Text(text)
            .font(name: "American Typewriter")
            .font(size: 14)
    }
}

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
        print("\n\n>>>")
        let view = PDFView()
        view.autoScales = true
        Task {
            if let data = try? await Document()
                .renderPDF(size: .letter, margins: .init(.in(0.5)))
            {
                view.document = PDFDocument(data: data)
            }
        }
        return view
    }
#endif
