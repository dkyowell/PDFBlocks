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
        VStack(spacing: 10) {
            Text("This is a sample text block that cannot be truncated.")
            Text("This is a sample text block that allows truncation.")
                .truncationMode(.tail)
                .frame(height: 120)
        }
        .font(.system(size: 44))
    }
}

#Preview {
    previewForDocument(Document())
}
