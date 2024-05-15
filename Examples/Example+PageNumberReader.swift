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
        VStack {
            // The first wrapping block encountered takes as much of the page space
            // as it can for its wrapping region. This is illustrated by turning
            // its background gray.
            VStack(wrapping: true) {
                Text("I Have a Dream")
                    .italic()
                    .fontSize(36)
                Text("Martin Luther King, Jr.")
                    .fontSize(18)
                    .padding(.bottom, 24)
                Columns(count: 3, spacing: 18, wrapping: true) {
                    Text(speech)
                        .fontSize(10)
                        .kerning(-0.25)
                }
                
            }
            .background(.gray.opacity(0.15))
            // Because this block is outside of the first wrapping block, it will be
            // repeated on every page.
            PageNumberReader { pageNo in
                Text("\(pageNo)")
                    .fontSize(10)
            }
            .padding(.top, 12)
        }
        .fontDesign(.serif)
    }
}

#Preview {
    previewForDocument(Document())
}

