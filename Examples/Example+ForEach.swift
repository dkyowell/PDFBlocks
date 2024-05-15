/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

private struct Document: Block {
    let weights: [Font.Weight] = [.ultraLight, .thin, .light, .regular, .medium, .semibold, .heavy, .black]
    let designs: [Font.Design] = [.default, .rounded, .serif, .monospaced]
    
    var body: some Block {
        VGrid(columnCount: 2, columnSpacing: 12, rowSpacing: 12) {
            ForEach(designs) { design in
                VStack {
                    ForEach(weights) { weight in
                        Text("One Fish")
                            .fontWeight(weight)
                    }
                }
                .fontDesign(design)
            }
        }
        .fontSize(36)
    }
}

#Preview {
    previewForDocument(Document())
}
