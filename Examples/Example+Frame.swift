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
            Group {
                Text("The quick brown fox jumped over the lazy dog.")
                Text("The quick brown fox jumped over the lazy dog.")
                Text("The quick brown fox jumped over the lazy dog.")
                Text("The quick brown fox jumped over the lazy dog.")
                Text("The quick brown fox jumped over the lazy dog.")
            }
            .bold()
            .padding(2)
            .border(.orange, width: 2)
            .font(.init(.init(name: "Courier", size: 42)))
        }
    }
}

#Preview {
    previewForDocument(Document())
}
