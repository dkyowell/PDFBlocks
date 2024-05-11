/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

private struct ExampleHStack: Block {
    var body: some Block {
        HStack(spacing: 10) {
            Color.purple
            Color.red
            Color.yellow
            Text("Pinky and the Brain")
                .fontSize(44)
            Color.orange
            Color.blue
            Color.green

        }
    }
}

#Preview {
    print("\n>>>")
    let view = PDFView()
    view.autoScales = true
    Task {
        if let data = try? await ExampleHStack().renderPDF() {
            view.document = PDFDocument(data: data)
        }
    }
    return view
}
