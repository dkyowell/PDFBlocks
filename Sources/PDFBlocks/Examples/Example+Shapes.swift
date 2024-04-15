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
                                        startRadius: .in(0),
                                        endRadius: .in(5))
    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            Text("Stroked Text")
                .padding(.horizontal, .max)
                .font(size: 72)
                .bold()
                .textStroke(color: .red, lineWidth: .pt(2))
            Arc(startAngle: .degrees(30), endAngle: .degrees(330), clockwise: false)
                .fill(radialGradient)
                .padding(.max)
                .stroke(linearGradient, lineWidth: .pt(24))
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
            path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
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

        let path = Path { path in
            for (n, pt) in vertices.enumerated() {
                n == 0 ? path.move(to: pt) : path.addLine(to: pt)
            }
            path.closeSubpath()
        }
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
