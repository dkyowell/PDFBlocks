/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        Page(size: .init(width: .in(6), height: .in(6)), margins: .in(1)) {
            HGrid(columnCount: 3, columnSpacing: 0, rowSpacing: 0, pageWrap: true) {
                Text("A")
                Text("B")
                Text("C")
                Text("D")
                Text("E")
                Text("F")
                Text("G")
                Text("H")
                Text("I")
                Text("J")
                Text("K")
                Text("L")
                Text("M")
                Text("N")
                Text("O")
                Text("P")
                Text("Q")
                Text("R")
                Text("S")
                Text("T")
                Text("U")
                Text("V")
                Text("W")
                Text("X")
                Text("Y")
                Text("Z")
            }
            .padding(12)
            .border(.blue, width: 12)
            .font(size: 32)
            .padding(12)
            .rotationEffect(.degrees(10))
        }
        .background {
            Color.orange
        }
        .border(Color.black, width: 12)
        .font(name: "American Typewriter")
    }
}

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
        print("\n>>>>")
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
