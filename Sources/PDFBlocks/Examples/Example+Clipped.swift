/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFKit

private struct Document: Block {
    var body: some Block {
        VStack(spacing: 72) {
            HStack(spacing: 72) {
                Square()
                    .fill(.red)
                Square()
                    .fill(.red)
                    .rotationEffect(.degrees(45))
            }
            HStack(spacing: 72) {
                Square()
                    .fill(.red)
                    .rotationEffect(.degrees(45))
                    .clipped()
                Square()
                    .fill(.red)
                    .rotationEffect(.degrees(45))
                    .clipped()
                    .overlay {
                        Text("STOP")
                            .foregroundStyle(.white)
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                    }
            }
        }
    }
}

#Preview {
    print("\n>>>")
    let view = PDFView()
    view.autoScales = true
    Task {
        if let data = try? await Document().renderPDF() {
            view.document = PDFDocument(data: data)
        }
    }
    return view
}
