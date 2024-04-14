/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
    let gradient = Gradient(colors: [.red, .orange, .yellow])
    let linearGradient = LinearGradient(colors: [.red, .orange, .yellow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing)
    let radial = RadialGradient(colors: [.red, .orange, .yellow],
                                center: .center,
                                startRadius: .in(0),
                                endRadius: .in(5))
    let customGradient = Gradient(stops: [.init(color: .red, location: 0),
                                          .init(color: .orange, location: 0.25),
                                          .init(color: .orange, location: 0.75),
                                          .init(color: .yellow, location: 1)])
    var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            VStack {
                Text("Outline")
                    .textStroke(color: .purple, lineWidth: .pt(4))
                Text("Blue")
                    .textStroke(color: .purple, lineWidth: .pt(4))
                    .textFill(.blue)
                Text("Linear")
                    .textStroke(lineWidth: .pt(2))
                Circle()
                    .fill(linearGradient)
            }
            .font(size: 128)
            .bold()
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
