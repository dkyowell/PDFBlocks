/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    @Environment(\.layoutAxis) var layoutAxis

    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            ZStack {
                Line(start: .topLeading, end: .bottomTrailing)
                Line(start: .bottomLeading, end: .topTrailing)
                Line(start: .top, end: .bottom)
                Line(start: .leading, end: .trailing)
            }
        }
        .stroke(.purple, style: .init(lineWidth: 20, lineCap: .round))
        Page(size: .letter, margins: .in(1)) {
            VStack {
                Line(start: .topLeading, end: .bottomTrailing)
                    .stroke(.green, style: .init(lineWidth: 20, lineCap: .round))
                Line(start: .bottomLeading, end: .topTrailing)
                    .stroke(.orange, style: .init(lineWidth: 20, lineCap: .round))
                Line(start: .top, end: .bottom)
                    .stroke(.blue, style: .init(lineWidth: 20, lineCap: .round))
                Line(start: .leading, end: .trailing)
                    .stroke(.cyan, style: .init(lineWidth: 20, lineCap: .round))
            }
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
                .renderPDF(size: .letter, margins: .init(.in(1)))
            {
                view.document = PDFDocument(data: data)
            }
        }
        return view
    }
#endif
