/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

let linearGradient = LinearGradient(stops: [.init(color: .yellow, location: 0),
                                            .init(color: .orange, location: 0.75),
                                            .init(color: .red, location: 0.95)],
                                    startPoint: .top,
                                    endPoint: .bottom)

let radialGradient = RadialGradient(colors: [.red, .orange, .yellow],
                                    center: .center,
                                    startRadius: .in(0),
                                    endRadius: .in(3))

private struct ExampleGradient: Block {
    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            Text("Hotter\nthan the\nMidday Sun")
                .foregroundStyle(linearGradient)
                .fontWeight(.black)
                .fontWidth(.expanded)
                .fontSize(64)
                .multilineTextAlignment(.center)
            Spacer(fixedLength: .in(1))
            Circle()
                .fill(radialGradient)
                .frame(height: .in(4))
        }
    }
}

#Preview {
    print("\n>>>>")
    let view = PDFView()
    view.autoScales = true
    Task {
        if let data = try? await ExampleGradient().renderPDF() {
            view.document = PDFDocument(data: data)
        }
    }
    return view
}
