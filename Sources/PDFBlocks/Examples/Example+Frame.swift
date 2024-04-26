/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
//        VStack(spacing: 10) {
//            Circle()
//                .foregroundStyle(.cyan)
//                .padding(40)
//                .border(.orange, width: 10)
//            Square()
//                .foregroundStyle(.pink)
//                .padding(40)
//                .border(.orange, width: 10)
//            Circle()
//                .foregroundStyle(.green)
//                .padding(40)
//                .border(.orange, width: 10)
//        }

        VStack(spacing: 10) {
            Group {
                Text("The quick brown fox jumped over the lazy dog.")
                Text("The quick brown fox jumped over the lazy dog.")
                Text("The quick brown fox jumped over the lazy dog.")
                Text("The quick brown fox jumped over the lazy dog.")
                Text("The quick brown fox jumped over the lazy dog.")
            }
            .bold()
            .padding(2)
            .border(.orange, width: 2)
            // .frame(height: 120)
            .font(name: "Courier", size: 48)
        }
    }
}

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
        print("\n\n>>>")
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
