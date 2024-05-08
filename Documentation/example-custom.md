##  Custom Component
As with a `View` in SwiftUI, you can write a reusable custom `Block` in PDFBlocks that is a composite of built-in primitive blocks. This example, which generates the PDFBlocks logo, uses a custom reusable component called `LetterBlock`.

### PDF
[example-custom.pdf](example-custom.pdf)
### Code

```swift
struct ExampleCustom: Block {
    var body: some Block {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 2) {
                ForEach(["P", "D", "F"]) { item in
                    LetterBlock(letter: item, color: .red)
                }
            }
            HStack(spacing: 2) {
                ForEach(["B", "L", "O", "C", "K", "S"]) { item in
                    LetterBlock(letter: item, color: .cyan)
                }
            }
        }
    }
}

struct LetterBlock: Block {
    let letter: String
    let color: Color
    var body: some Block {
        Text(letter)
            .foregroundColor(.white)
            .frame(width: 84, height: 84, alignment: .center)
            .background(color)
            .font(.init(.init(name: "American Typewriter", size: 68)))
            .bold()
    }
}
```
