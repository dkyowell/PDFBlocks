<p align="left">
    <img src="Documentation/logo.png" width="300" max-width="50%" alt=“PDFBlocks” />
</p>
<p align="left">
    <img src="https://img.shields.io/badge/swift-5.9-orange.svg" />
    <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    <img src="https://img.shields.io/badge/platforms-macOS+iOS-brightgreen.svg?style=flat" alt="Mac + iOS" />
</p>

PDFBlocks is a powerful but easy to use PDF document and report generation library written in Swift for Apple platforms. 

## A Declarative Approach to Documents. 
PDFBlocks uses a declarative language inspired by SwiftUI for describing document layout and appearance. Here is the code that was used to generate the PDFBlocks logo at the top of this page.

```swift
private struct Document: Block {
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

private struct LetterBlock: Block {
    let letter: String
    let color: Color
    var body: some Block {
        Text(letter)
            .foregroundColor(.white)
            .frame(width: 48, height: 48, alignment: .center)
            .background(color)
            .font(Font(.init(name: "American Typewriter", size: 36)))
            .bold()
    }
}
```

## Easy to Write Reports.
Tables in PDFBlocks are aware of the data type of the table, so you can define table columns and groups based on key
 paths with implied types. This makes writing reports a breeze with editor autocompletion.
```swift
struct Document: Block {
    let data: [Donor]

    var body: some Block {
        Table(data) {
            TableColumn("Last Name", value: \.lastName, width: 20)
            TableColumn("First Name", value: \.firstName, width: 20)
            TableColumn("Address", value: \.address, width: 35)
            TableColumn("City", value: \.city, width: 25)
            TableColumn("State", value: \.state, width: 10)
            TableColumn("Zip", value: \.zip, width: 10)
            TableColumn("DOB", value: \.dob, format: .mmddyy, width: 10, alignment: .trailing)
        } groups: {
            TableGroup(on: \.state, order: <, spacing: .pt(12)) { rows, value in
                Text(stateName(abberviation: value))
                    .font(size: 14)
                    .bold()
            } footer: { rows, value in
                Divider()
                Text("\(rows.count) records for \(stateName(abberviation: value))")
                    .bold()
                    .padding(.leading, .max)
            }
        }
    }
}

let pdfData = Document().renderPDF(pageSize: .letter, margins: .in(1))

```
<p align="center">
    <img src="Documentation/table-image.png" width="600" max-width="75%" alt=“Table Image” />
</p>

## Documentation
[Documentation.md](Documentation/Documentation.md)


## For a Quick "Preview"
You can get a quick start with using PDFBlocks using the example documents and XCode Previews.

1. Download the PDFBlocks project.
2. Open Package.swift in XCode.
3. Navigate to Sources/PDFBlocks/Examples
4. Puruse the sample documents. Modify them if you wish, and see the results right away using Xcode Previews.

<p align="center">
    <img src="Documentation/xcode-preview.png" width="400" max-width="50%" alt=“Xcode Preview” />
</p>

## Installation
PDFBlocks is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/dkyowell/pdfblocks.git", from: "0.2.4")
    ],
    ...
)
```

Then import PDFBlocks wherever you’d like to use it:

```swift
import PDFBlocks
```

## Support
Open an issue with questions or feature requests. I am actively developing this project and will try to accomodate requests that fit within the goals of the project. 
