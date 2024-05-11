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
        Page(size: .init(width: .in(4), height: .in(6)), margins: .in(0.5)) {
            Group {
                Text("Ultralight")
                    .fontWeight(.ultraLight)
                Text("Thin")
                    .fontWeight(.thin)
                Text("Light")
                    .fontWeight(.light)
                Text("Regular")
                    .fontWeight(.regular)
                Text("Medium")
                    .fontWeight(.medium)
                Text("Semibold")
                    .fontWeight(.semibold)
                Text("Bold")
                    .fontWeight(.bold)
                Text("Heavy")
                    .fontWeight(.heavy)
                Text("Black")
                    .fontWeight(.black)
            }
            .font(Font(.init(name: "Helvetica Neue", size: 24)))
        }
        .border(.black, width: 4)
    }
}

#Preview {
    previewForDocument(Document())
}
