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
        Page(size: .init(width: .in(4), height: .in(6)), margins: .in(1)) {
            VStack(wrapping: true) {
                VStack(spacing: 12, wrapping: true) {
                    Text("One")
                    Text("Fish")
                    Text("Two")
                    Text("Fish")
                    Text("Red")
                        .foregroundStyle(.red)
                        .scaleEffect(1.25)
                    Text("Fish")
                    Text("Blue")
                        .foregroundStyle(.blue)
                        .scaleEffect(1.25)
                    Text("Fish")
                    Color.orange
                }
            }
            .font(.init(.init(name: "American Typewriter", size: 24)))
        }
        .border(.black, width: 4)
    }
}

#Preview {
    previewForDocument(Document())
}
