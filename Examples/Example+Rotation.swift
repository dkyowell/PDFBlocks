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
        Page(size: .init(width: .in(8), height: .in(8)), margins: .in(1)) {
            VGrid(columnCount: 3, columnSpacing: 24, rowSpacing: 24) {
                Repeat(count: 9) {
                    VGrid(columnCount: 3, columnSpacing: 4, rowSpacing: 4) {
                        Group {
                            Color.red
                            Color.blue
                            Color.purple
                            Color.purple
                            Color.red
                            Color.blue
                            Color.blue
                            Color.purple
                            Color.red
                        }
                        .rotationEffect(.degrees(5))
                        .aspectRatio(1)
                    }
                }
            }
        }
        .opacity(0.5)
    }
}

#Preview {
    previewForDocument(Document())
}
