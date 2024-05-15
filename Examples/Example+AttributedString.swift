/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

private struct Document: Block {
    let text: AttributedString = {
        var result: AttributedString = "One fish\nTwo fish\nRed fish\nBlue fish"
        if let range = result.range(of: "Blue") {
            result[range].foregroundColor = .systemBlue
        }
        if let range = result.range(of: "Red") {
            result[range].foregroundColor = .systemRed
        }
        return result
    }()

    var body: some Block {
        Text(text)
            .fontSize(64)
            .fontDesign(.serif)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    previewForDocument(Document())
}
