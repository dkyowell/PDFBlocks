/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    let linearGradient = LinearGradient(colors: [.cyan, .purple, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing)
    let radialGradient = RadialGradient(colors: [.red, .orange, .yellow],
                                        center: .center,
                                        startRadius: .in(3),
                                        endRadius: .in(8))
    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            HStack(spacing: .pt(16)) {
                Arc(startAngle: .degrees(35), endAngle: .degrees(325), clockwise: false)
                    .fill(.yellow)
                    .stroke(.black, lineWidth: .pt(4))
                    .padding(.max)
                ForEach(Array(0 ... 10)) { _ in
                    Circle()
                        .frame(height: 10)
                }
            }
        }
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
