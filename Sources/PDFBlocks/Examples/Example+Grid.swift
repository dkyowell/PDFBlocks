/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// what is a way to repeat an entire page except for the repeatable part?

// PageWrap
//
// A VStack, Grid, or Table that allows PageWrap will take all proposed spaces.
// If a PageWrap is already within a PageWrap region, then it will take zero height.


// IDEA: allow overlay with multipage by pushing onto a stack.

private struct Document: Block {
    var body: some Block {
        Page(size: .init(width: .in(6), height: .in(6)), margins: .in(1)) {
            Grid(columnCount: 3, columnSpacing: .in(0), rowSpacing: .in(0.5), allowPageWrap: true) {
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
            }
            .font(size: 36)
            .padding(.pt(24))
            .background {
                Color.blue
                    .padding(.pt(12))
            }
            .overlay {
                Color.orange
                    .padding(.pt(36))
            }
            .border(color: .green, width: .pt(4))
            .padding(.pt(12))
            .border(color: .green, width: .pt(4))
        }
        .background {
            Color.yellow
        }
        .border(color: .black, width: .pt(12))
    }
}

private struct LetterBlock: Block {
    let letter: String
    let color: Color
    var body: some Block {
        Text(letter)
            .foregroundColor(.white)
            .frame(width: .pt(48), height: .pt(48), alignment: .center)
            .background { color }
            .font(name: "American Typewriter", size: 36)
            .bold()
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
