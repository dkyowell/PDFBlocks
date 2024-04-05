/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        VStack(spacing: .pt(12)) {
            HStack(spacing: .pt(4)) {
                Text("Leading")
                    .proportionalFrame(width: 1, alignment: .leading)
                    .background { Color.red.opacity(0.5) }
                Text("Center")
                    .proportionalFrame(width: 3, alignment: .center)
                    .background { Color.green.opacity(0.5) }
                Text("Trailing")
                    .proportionalFrame(width: 1, alignment: .trailing)
                    .background { Color.blue.opacity(0.5) }
            }
            HStack(spacing: .pt(4)) {
                Text("Leading")
                    .proportionalFrame(width: 3, alignment: .leading)
                    .background { Color.red.opacity(0.5) }
                Text("Center")
                    .proportionalFrame(width: 2, alignment: .center)
                    .background { Color.green.opacity(0.5) }
                Text("Trailing")
                    .proportionalFrame(width: 1, alignment: .trailing)
                    .background { Color.blue.opacity(0.5) }
            }
        }
        .font(size: 14)
    }
}

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
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
