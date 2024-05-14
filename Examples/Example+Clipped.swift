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
        VStack(spacing: 72) {
            HStack(spacing: 72) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("1. Fill")
                    Square()
                        .fill(.red)
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("2. Rotate")
                        .offset(x: -24, y: 0)
                    Square()
                        .fill(.red)
                        .rotationEffect(.degrees(45))
                }
            }
            HStack(spacing: 72) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("3. Clip")
                    Square()
                        .fill(.red)
                        .rotationEffect(.degrees(45))
                        .clipped()
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("4. Overlay")
                        .offset(x: -24, y: 0)
                    Square()
                        .fill(.red)
                        .rotationEffect(.degrees(45))
                        .clipped()
                        .overlay {
                            Text("STOP")
                                .foregroundStyle(.white)
                                .font(.system(size: 60))
                                .fontWeight(.heavy)
                        }
                }
            }
        }
        .fontSize(24)
    }
}

#Preview {
    previewForDocument(Document())
}
