/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFKit

let linearGradient = LinearGradient(colors: [.cyan, .purple, .blue],
                                    startPoint: .top,
                                    endPoint: .bottom)

let radialGradient = RadialGradient(colors: [.red, .orange, .yellow],
                                    center: .center,
                                    startRadius: .in(0),
                                    endRadius: .in(3))

private struct Document: Block {
    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            Text("Houston\nAstros")
                .foregroundStyle(radialGradient)
                .font(Font(.init(name: "Rockwell", size: 80)))
                .fontWeight(.black)
                .multilineTextAlignment(.center)
            Spacer(fixedLength: .in(1))
            Circle()
                .fill(linearGradient)
                .frame(height: .in(4))
        }
    }
}

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
