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
        Text("Orange\nCrush")
            .fontSize(144)
            .textStroke(color: .blue, lineWidth: 3)
            .textFill(.orange)
            .font(.init(.init(name: "Courier", size: 164)))
            .italic()
            .bold()
            .kerning(-13)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    previewForDocument(Document())
}
