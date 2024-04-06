/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    let text = "The quick brown fox jumped over the lazy cow. The quick brown fox jumped over the lazy cow. The quick brown fox jumped over the lazy cow. The quick brown fox jumped over the lazy cow. "
    var body: some Block {
        ForEach([TextAlignment.leading, .center, .trailing, .justified]) { alignment in
            Text(text)
                .font(size: 18)
                .multilineTextAlignment(alignment)
            Divider(padding: .pt(12))
        }
    }
}

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
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
