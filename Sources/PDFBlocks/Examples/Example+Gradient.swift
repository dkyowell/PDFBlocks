/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    let linearGradient = LinearGradient(colors: [.cyan, .purple, .blue],
                                        startPoint: .top,
                                        endPoint: .bottom)
    let radialGradient = RadialGradient(colors: [.red, .orange, .yellow],
                                        center: .center,
                                        startRadius: .in(0),
                                        endRadius: .in(3))
    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            HStack(spacing: .pt(16)) {
                Circle()
                    .fill(linearGradient)
                Circle()
                    .fill(radialGradient)
            }
        }
    }
}

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
        print("\n>>>>")
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
