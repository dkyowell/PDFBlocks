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
        // Text is truncated when constrained
        Text("The quick brown fox jumped over the lazy dog.")
            .fontSize(42)
            .fontDesign(.rounded)
            .fontWeight(.bold)
            // .frame is used to constrain element
            .frame(width: .in(3), height: .in(3))
            .border(.orange)
            .padding(12)
            // .frame is used to align element
            .frame(width: .max, height: .max, alignment: .bottomTrailing)
            .border(.cyan)
    }
}

#Preview {
    previewForDocument(Document())
}
