/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        Page(size: .init(width: .in(6), height: .in(6)), margins: .in(1)) {
            Square()
                .fill(.red)
                .rotationEffect(.degrees(45))
                .overlay {
                    VStack(allowWrap: false) {
                        Text("STOP")
                    }
                    .foregroundColor(.white)
                    .font(size: 90)
                    .bold()
                }
                .clipped()
        }
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
