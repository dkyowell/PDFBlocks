/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

private struct Document: Block {
    let text = "The quick brown fox jumped over the lazy cow. The quick brown fox jumped over the lazy cow. The quick brown fox jumped over the lazy cow. The quick brown fox jumped over the lazy cow. "
    var body: some Block {
        VStack(spacing: .flex) {
            ForEach([TextAlignment.leading, .center, .trailing]) { alignment in
                Text(text)
                    .multilineTextAlignment(alignment)
            }
        }
        .fontSize(20)
        .padding(.vertical, 72)
    }
}

#Preview {
    previewForDocument(Document())
}
