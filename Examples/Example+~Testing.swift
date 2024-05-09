/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFKit
import PDFBlocks

private struct Document: Block {
    var body: some Block {
        ZStack {
            ForEach([0, 30, 60, 90]) { angle in
                Text("Rotated Text")
                    .rotationEffect(.degrees(angle), anchor: .leading)
            }
            .fontSize(84)
        }
        .padding(.bottom, .max)
    }
}

#Preview {
    print("\n>>>")
    let view = PDFView()
    view.autoScales = true
    Task {
        if let data = try? await Document().renderPDF() {
            view.document = PDFDocument(data: data)
        }
    }
    return view
}
