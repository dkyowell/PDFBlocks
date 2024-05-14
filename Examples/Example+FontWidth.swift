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
        VStack(spacing: 24) {
            Text("Where no man has gone before")
                .fontWidth(.compressed)
            Text("Where no man has gone before")
                .fontWidth(.condensed)
            Text("Where no man has gone before")
                .fontWidth(.standard)
            Text("Where no man has gone before")
                .fontWidth(.expanded)
        }
        .fontSize(24)
    }
}

#Preview {
    previewForDocument(Document())
}
