/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        Page(size: .init(width: .in(6), height: .in(6)), margins: .in(1)) {
            VStack(alignment: .center, spacing: 12, allowWrap: true) {
                VStack(spacing: 0, allowWrap: false) {
                    Text("One")
                        .padding(4)
                        .border(.red)
                    Text("Two")
                        .padding(4)
                        .border(.red)
                    Text("Three")
                        .padding(4)
                        .border(.red)
                    Text("Four")
                        .padding(4)
                        .border(.red)
                    Text("Five")
                        .padding(4)
                        .border(.red)
                    Text("Six")
                        .padding(4)
                        .border(.red)
                    Text("Seven")
                        .padding(4)
                        .border(.red)
                    Color.orange
                        .tag("Orange")
                    Text("Eight")
                        .padding(4)
                        .border(.red)
                }
                .tag("Pinky")
                // .padding(12)
                .border(.cyan)
//                Text("Four")
//                    .padding(4)
//                    .border(.red)
//                Color.cyan
//                    .padding(4)
//                    .border(.red)
//                Text("Five")
//                    .padding(4)
//                    .border(.red)
//                Color.cyan
//                    .padding(4)
//                    .border(.red)
//                Text("Six")
//                    .padding(4)
//                    .border(.red)
//                Text("Seven")
//                    .padding(4)
//                    .border(.red)
//                Text("Three")
//                    .padding(4)
//                    .border(.red)
            }
            .frame(alignment: .center)
            .padding(12)
            .border(.black)
            // .clipped()
            .font(size: 24)
        }
    }
}

private let text = "They're Pinky and the Brain, Pinky and the Brain. One is a genious. The other's insane. They're labratory mice. They're genes have been spliced. They're Pinky, they're Pink and the Brain Brain Brain Brain."

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
