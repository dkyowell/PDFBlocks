/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

struct ExampleColumns: Block {
    var body: some Block {
        VStack(wrap: true) {
            Text("I Have a Dream")
                .italic()
                .fontSize(36)
            Text("Martin Luther King, Jr.")
                .fontSize(18)
                .padding(.bottom, 24)
            Columns(count: 3, spacing: 18, wrap: true) {
                Text(speech)
                    .kerning(-0.25)
                    .truncationMode(.wrap)
            }
        }
        .fontDesign(.serif)
        .fontSize(10)
    }
}

#Preview {
    previewForDocument(ExampleColumns())
}
