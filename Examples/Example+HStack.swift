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
        HStack(spacing: 10) {
            Color.purple
            Color.red
            Color.yellow
            Text("Pinky and the Brain.")
                .fontSize(44)
            Color.orange
            Color.blue
            Color.green
        }
    }
}

#Preview {
    previewForDocument(Document())
}
