##  Gradient Fill
A `Shape` or `Text` can be filled with either a `Color`, a `LinearGradient`, or a `RadialGradient`.

### PDF
[example-gradient.pdf](example-gradient.pdf)
### Code

```swift


struct ExampleGradient: Block {
    let linearGradient = LinearGradient(stops: [.init(color: .yellow, location: 0),
                                                .init(color: .orange, location: 0.75),
                                                .init(color: .red, location: 0.95)],
                                        startPoint: .top,
                                        endPoint: .bottom)

    let radialGradient = RadialGradient(colors: [.red, .orange, .yellow],
                                        center: .center,
                                        startRadius: .in(0),
                                        endRadius: .in(3))

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


```
