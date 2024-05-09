/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

private struct Document: Block {
    let text = "The quick brown fox jumped over the lazy cow. The quick brown fox jumped over the lazy cow. The quick brown fox jumped over the lazy cow. The quick brown fox jumped over the lazy cow. "
    var body: some Block {
        VStack {
            ForEach([TextAlignment.leading, .center, .trailing]) { alignment in
                Text(text)
                    .fontSize(18)
                    .multilineTextAlignment(alignment)
                if alignment != .trailing {
                    Divider(padding: .pt(12))
                }
            }
        }
        .padding(.vertical, .max)
    }
}

#Preview {
    let view = PDFView()
    view.autoScales = true
    Task {
        if let data = try? await Document().renderPDF() {
            view.document = PDFDocument(data: data)
        }
    }
    return view
}
