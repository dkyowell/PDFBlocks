/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

// RotationEffect, ScaleEffect, and Offset change the appearance of the elements, but do not
// change their true size as concerns layout within a stack.

private struct Document: Block {
    var body: some Block {
        VStack(spacing: 20) {
            Text("Red")
                .foregroundStyle(.red)
                .scaleEffect(1.5)
                // This border shows the true size and position.
                .border(.black)
            Text("Fish")
            Text("Blue")
                .foregroundStyle(.blue)
                // This border is scaled along with the text.
                .border(.black)
                .scaleEffect(1.5)
            Text("Fish")
            Text("Red")
                .foregroundStyle(.red)
                .rotationEffect(.degrees(-45))
                // This border shows the true size and position.
                .border(.black)
            Text("Fish")
            Text("Blue")
                .foregroundStyle(.blue)
                // This border is rotated along with the text.
                .border(.black)
                .rotationEffect(.degrees(-45))
            Text("Fish")
        }
        .font(.init(.init(name: "American Typewriter", size: 48)))
    }
}

#Preview {
    previewForDocument(Document())
}
