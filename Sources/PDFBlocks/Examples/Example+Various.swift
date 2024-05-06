/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// THERE ARE ONLY THREE WRAPPING BLOCKS: VSTACK, HGRID, & TABLE.

// ANY BLOCK CAN MAKE ITSELF WRAPPABLE
// WRAP IN A

private struct Document: Block {
    var body: some Block {
        Page(size: .init(width: .in(8), height: .in(8)), margins: .in(1)) {
            VGrid(columnCount: 3, columnSpacing: 12, rowSpacing: 12, pageWrap: true) {
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
                    .opacity(0.5)
                }
                Square()
                    .fill(.cyan)
                    .rotationEffect(.degrees(2))
                Text("The")
                Text("Quick")
                Text("Brown")
                Text("Fox")
                Text("Jumped")
                Text("Over")
                Text("The")
                Text("Lazy")
                Text("Dog")
                Text("And")
                Text("Cat")
                Text("The")
                Text("Quick")
                Text("Brown")
            }
            .fontSize(32)
        }
    }
}

private let text = "They're Pinky and the Brain, Pinky and the Brain. One is a genius. The other's insane. They're labratory mice. They're genes have been spliced. They're Pinky, they're Pink and the Brain Brain Brain Brain."

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
        print("\n>>>")
        let view = PDFView()
        view.autoScales = true
        Task {
            if let data = try? await Document()
                .renderPDF(size: .letter, margins: .init(.in(1)))
            {
                view.document = PDFDocument(data: data)
            }
        }
        return view
    }
#endif
