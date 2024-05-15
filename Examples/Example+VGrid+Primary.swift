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
        Page(size: .init(width: .in(6), height: .in(6)), margins: .in(1)) {
            VGrid(columnCount: 3, columnSpacing: 0, rowSpacing: 0) {
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
            .padding(24)
            .rotationEffect(.degrees(10))
        }
        .background(.orange)
        .border(Color.black, width: 12)
        .font(.system(size: 42, design: .serif))
    }
}

#Preview {
    previewForDocument(Document())
}
