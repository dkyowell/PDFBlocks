/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

struct ExampleShapes: Block {
    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            HStack(spacing: 32) {
                Arc(startAngle: .degrees(35), endAngle: .degrees(325), clockwise: false)
                    .fill(.yellow)
                    .stroke(.black, lineWidth: 3)
                    .frame(height: 150)
                Line(start: .leading, end: .trailing)
                    .stroke(.white, style: StrokeStyle(lineWidth: .pt(15), lineCap: .round, dash: [0, 80]))
            }
        }
        .background(.black)
        .border(.blue, width: 10)
    }
}

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    func path(in rect: CGRect) -> Path {
        Path { path in
            let radius = min(rect.width, rect.height) / 2
            path.addLines([CGPoint(x: rect.midX, y: rect.midY)])
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
            path.closeSubpath()
        }
    }

    public func sizeThatFits(_ proposal: CGSize) -> CGSize {
        let minLength = min(proposal.width, proposal.height)
        return .init(width: minLength, height: minLength)
    }
}

#Preview {
    previewForDocument(ExampleShapes())
}
