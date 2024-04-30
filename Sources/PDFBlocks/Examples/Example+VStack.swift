/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        Page(size: .init(width: .in(4), height: .in(6)), margins: .in(1)) {
            VStack(spacing: .flex) {
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
            }
            .font(.init(.init(name: "American Typewriter", size: 24)))
        }
        .border(.black, width: 4)
    }
}

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
