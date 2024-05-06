/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFKit

private struct Document: Block {
    var body: some Block {
        Repeat(count: 20) {
            Text("ABC")
        }
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
