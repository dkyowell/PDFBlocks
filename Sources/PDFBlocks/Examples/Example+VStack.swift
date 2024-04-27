/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        Page(size: .init(width: .in(8), height: .in(6)), margins: .in(0.5)) {
            VStack(spacing: .flex) {
                Text("The")
                Text("Quick")
                Text("Brown")
                Text("Fox")
                Color.pink.opacity(0.5)
                Text("Jumped")
                Text("Over")
                Text("The")
                Text("Lazy")
                Text("Dog")
            }
            .foregroundStyle(.purple)
            .padding(8)
            .border(.cyan, width: 4)
            //.frame(height: 144)
            .padding(8)
            //.border(.orange, width: 4)
            .font(.init(NSUIFont(name: "American Typewriter", size: 20)!))
            .background(.gray.opacity(0.25))
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
