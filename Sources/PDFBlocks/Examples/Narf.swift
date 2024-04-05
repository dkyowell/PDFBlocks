/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        Text("They're Pink and the Brain. Pinky and the Brain. One is a genius. The other's insane. They're labratory mice. They're Pink and the Brain. Pinky and the Brain. One is a genius. The other's insane. They're labratory mice.")
            .font(size: 24)
            .multilineTextAlignment(.center)
            .border(color: .red, width: .pt(24))
        FixedSpace(size: .pt(72))
        Divider(size: .pt(4))
            .padding(vertical: .pt(6))
        Text("They're Pink and the Brain. Pinky and the Brain. One is a genius. The other's insane. They're labratory mice. They're Pink and the Brain. Pinky and the Brain. One is a genius. The other's insane. They're labratory mice.")
            .font(size: 24)
            .multilineTextAlignment(.leading)
        Divider()
            .padding(vertical: .pt(6))
        Text("They're Pink and the Brain. Pinky and the Brain. One is a genius. The other's insane. They're labratory mice. They're Pink and the Brain. Pinky and the Brain. One is a genius. The other's insane. They're labratory mice.")
            .font(size: 24)
            .multilineTextAlignment(.trailing)
        Divider()
            .padding(vertical: .pt(6))
        Text("They're Pink and the Brain. Pinky and the Brain. One is a genius. The other's insane. They're labratory mice. They're Pink and the Brain. Pinky and the Brain. One is a genius. The other's insane. They're labratory mice.")
            .font(size: 24)
            .multilineTextAlignment(.justified)
    }
}

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
        let view = PDFView()
        view.autoScales = true
        Task {
            if let data = try? await Document()
                .renderPDF(size: .letter, margins: .init(.in(0.5)))
            {
                view.document = PDFDocument(data: data)
            }
        }
        return view
    }
#endif
