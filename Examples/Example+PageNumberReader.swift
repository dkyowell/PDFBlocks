/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

public struct ExamplePageNumberReader: Block {
    public init() {}
    public var body: some Block {
        VStack {
            // The first wrapping block encountered takes as much of the page space
            // as it can for its wrapping region. This is illustrated by turning
            // its background gray.
            VStack(wrap: true) {
                Text("I Have a Dream")
                    .italic()
                    .fontSize(36)
                Text("Martin Luther King, Jr.")
                    .fontSize(18)
                    .padding(.bottom, 24)
                Columns(count: 3, spacing: 18, wrap: true) {
                    Text(speech)
                        .fontSize(10)
                        .kerning(-0.25)
                        .truncationMode(.wrap)
                }
            }
            .background(.gray.opacity(0.15))
            // Because this block is outside of the first wrapping block, it will be
            // repeated on every page.
            PageNumberReader(computePageCount: true) { proxy in
                Text("\(proxy.pageNo) / \(proxy.pageCount)")
                    .fontSize(10)
            }
            .padding(.top, 12)
        }
        .fontDesign(.serif)
    }
}

#Preview {
    previewForDocument(ExamplePageNumberReader())
}

