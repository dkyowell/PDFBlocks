##  Column Layout

The `Columns` component allows you to layout your content in columns that will auto-size themselves for even column lengths.
### PDF
[example-columns.pdf](example-columns.pdf)
### Code

```swift
struct ExampleColumns: Block {
    let speech = "..."
    
    var body: some Block {
        VStack(pageWrap: true) {
            Text("I Have a Dream")
                .italic()
                .fontSize(36)
            Text("Martin Luther King, Jr.")
                .fontSize(18)
                .padding(.bottom, 24)
            Columns(count: 3, spacing: 18, pageWrap: true) {
                Text(speech)
                    .fontSize(10)
                    .kerning(-0.25)
            }
        }
        .fontDesign(.serif)
    }
}
```
