##  Vector Drawing
PDFBlocks has a built-in `Line` component and shapes for `Rectangle`, `Ellipse`, `Circle`, `Square`, `RoundedRectangle`, and `Capsule`. Custom vector drawing can be accomplished by creating a struct that conforms to the `Shape` protocol as with the `Arc` shape in this example. Code for SwiftUI custom shapes found on GitHub or blogs can usually be copied straight into PDFBlocks.

### PDF
[example-vector.pdf](example-vector.pdf)
### Code

```swift
struct ExampleVectorDrawing: Block {
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

```
