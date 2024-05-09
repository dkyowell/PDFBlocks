/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks

private struct Document: Block {
    var body: some Block {
        VStack(spacing: 12) {
            Text("Equal Proportions")
            HStack(spacing: 4) {
                Text("x 1")
                    .proportionalFrame(width: 1, alignment: .center)
                    .background { Color.red.opacity(0.5) }
                Text("x 1")
                    .proportionalFrame(width: 1, alignment: .center)
                    .background { Color.green.opacity(0.5) }
                Text("x 1")
                    .proportionalFrame(width: 1, alignment: .center)
                    .background { Color.blue.opacity(0.5) }
            }
            .padding(.bottom, 12)
            Text("Center Twice as Wide as Ends")
            HStack(spacing: 4) {
                Text("x 1")
                    .proportionalFrame(width: 1, alignment: .center)
                    .background { Color.red.opacity(0.5) }
                Text("x 2")
                    .proportionalFrame(width: 2, alignment: .center)
                    .background { Color.green.opacity(0.5) }
                Text("x 1")
                    .proportionalFrame(width: 1, alignment: .center)
                    .background { Color.blue.opacity(0.5) }
            }
            .padding(.bottom, 12)
            Text("Block 1 Width + Block 2 Width = Block 3 Width")
            HStack(spacing: 4) {
                Text("x 1")
                    .proportionalFrame(width: 1, alignment: .center)
                    .background { Color.red.opacity(0.5) }
                Text("x 2")
                    .proportionalFrame(width: 2, alignment: .center)
                    .background { Color.green.opacity(0.5) }
                Text("x 3")
                    .proportionalFrame(width: 3, alignment: .center)
                    .background { Color.blue.opacity(0.5) }
            }
            .padding(.bottom, 12)
            Text("Block 1 = 35%, Block 2 = 20%, Block 3 = 55%")
            HStack(spacing: 4) {
                Text("35%")
                    .proportionalFrame(width: 35, alignment: .center)
                    .background { Color.red.opacity(0.5) }
                Text("20%")
                    .proportionalFrame(width: 20, alignment: .center)
                    .background { Color.green.opacity(0.5) }
                Text("55%")
                    .proportionalFrame(width: 55, alignment: .center)
                    .background { Color.blue.opacity(0.5) }
            }
        }
        .fontSize(18)
    }
}

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
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
