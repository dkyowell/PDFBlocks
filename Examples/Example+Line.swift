/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

private struct Document: Block {
    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            Line(start: .init(x: 0.25, y: 0.25), end: .init(x: 0.75, y: 0.75))
                .stroke(.black, style: StrokeStyle(lineWidth: 2))
        }
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
