/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// import AppKit

private struct Document: Block {
    var body: some Block {
        Page(size: .init(width: .in(4), height: .in(6)), margins: .in(0.5)) {
            Text("Test")
                .font(.system(size: 18))
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
