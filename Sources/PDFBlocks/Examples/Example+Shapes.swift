/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            VStack(spacing: .in(0.5)) {
                Square()
                    .border(color: .blue)
                Rectangle()
                RoundedRectangle(cornerRadius: .pt(8))
                Capsule()
                Circle()
                    .border(color: .blue)
                Ellipse()
                StarShape()
                    .border(color: .blue)
            }
            .strokeLineWidth(.pt(4))
            .strokeColor(.red)
            .fill(Color(UIColor.green.withAlphaComponent(0)))
            // .frame(width: .in(2), height: .in(2))
            .padding(.max)
        }
    }
}

struct StarShape: Shape {
    var points = 5

    func Cartesian(length: Double, angle: Double) -> CGPoint {
        CGPoint(x: length * cos(angle),
                y: length * sin(angle))
    }

    func path(in rect: CGRect) -> Path {
        var center = CGPoint(x: rect.midX, y: rect.midY)
        // Adjust center down for odd number of sides less than 8
        if points % 2 == 1, points < 8 {
            center = CGPoint(x: center.x, y: center.y * ((Double(points) * -0.04) + 1.3))
        }

        // radius of a circle that will fit in the rect
        let outerRadius = (Double(min(rect.width, rect.height)) / 2.0) * 0.9
        let innerRadius = outerRadius * 0.4
        let offsetAngle = (Double.pi / Double(points)) + Double.pi / 2.0

        var vertices: [CGPoint] = []
        for i in 0 ..< points {
            // Calculate the angle in Radians
            let angle1 = (2.0 * Double.pi / Double(points)) * Double(i) + offsetAngle
            let outerPoint = Cartesian(length: outerRadius, angle: angle1)
            vertices.append(CGPoint(x: outerPoint.x + center.x, y: outerPoint.y + center.y))

            let angle2 = (2.0 * Double.pi / Double(points)) * (Double(i) + 0.5) + offsetAngle
            let innerPoint = Cartesian(length: innerRadius,
                                       angle: angle2)
            vertices.append(CGPoint(x: innerPoint.x + center.x, y: innerPoint.y + center.y))
        }

        var path = Path()
        for (n, pt) in vertices.enumerated() {
            n == 0 ? path.move(to: pt) : path.addLine(to: pt)
        }
        path.closeSubpath()
        return path
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
