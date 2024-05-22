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
        HStack(alignment: .center, spacing: 10) {
            Rectangle().fill(.pink)
            Text("They're Pinky and the Brain.\nThey're Pinky and the Brain.\nOne is a genius.\nThe other's insane.")
            Rectangle().fill(.cyan)
            Text("They're Pinky and the Brain.\nThey're Pinky and the Brain.\nOne is a genius.\nThe other's insane.")
            Rectangle().fill(.pink)
        }
        .truncationMode(.none)
        .fontWidth(.compressed)
        .fontSize(18)
    }
}

#Preview {
    previewForDocument(Document())
}
