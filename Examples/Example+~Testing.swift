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
        VStack(spacing: 12, wrapContents: true) {
            Repeat(count: 20) {
                Text("Section One")
                VStack(spacing: 12, wrapContents: true) {
                    Repeat(count: 4) {
                        Text("Section Two")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .fontSize(24)
        .fontSize(24)
    }
}

#Preview {
    previewForDocument(Document())
}
