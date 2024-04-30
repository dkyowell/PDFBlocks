/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        Text("Narf")
            .font(size: 164)
            .textStroke(color: .blue, lineWidth: 3)
            .textFill(.orange)
            .font(.init(.init(name: "Courier", size: 164)))
            .italic()
            .bold()
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
                .renderPDF(size: .letter, margins: .init(.in(0)))
            {
                view.document = PDFDocument(data: data)
            }
        }
        return view
    }
#endif
