/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        VStack(spacing: .pt(12)) {
            HStack(alignment: .top, spacing: .pt(4)) {
                Text("Leading")
                    // .frame(height: .in(0.5), alignment: .bottomLeading)
                    .background { Color.purple.opacity(0.5) }
                    .proportionalFrame(width: 1, alignment: .leading)
                    .background { Color.red.opacity(0.5) }
                Text("Center")
                    .frame(height: .in(1))
                    .proportionalFrame(width: 2, alignment: .center)
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
            HStack(alignment: .center, spacing: .pt(4)) {
                Text("Leading")
                    .background { Color.red.opacity(0.5) }
                Text("Center")
                    .frame(height: .in(1), alignment: .bottom)
                    .background { Color.green.opacity(0.5) }
                Text("Trailing")
                    .background { Color.blue.opacity(0.5) }
            }
            HStack(spacing: .pt(2)) {
                Text("Leading")
                    .proportionalFrame(width: 30, alignment: .leading)
                Text("Leading")
                    .proportionalFrame(width: 10, alignment: .leading)
                Text("Leading")
                    .proportionalFrame(width: 10, alignment: .leading)
                Text("Leading")
                    .proportionalFrame(width: 10, alignment: .leading)
                Text("Leading")
                    .proportionalFrame(width: 10, alignment: .leading)
                Text("Leading")
                    .proportionalFrame(width: 10, alignment: .leading)
                Text("Leading")
                    .proportionalFrame(width: 10, alignment: .leading)
                Text("Leading")
                    .proportionalFrame(width: 10, alignment: .leading)
            }
            .font(size: 12)
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
