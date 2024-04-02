<p align="center">
    <img src="Documentation/logo.png" width="400" max-width="50%" alt=“PDFBlocks” />
</p>
<p align="center">
    <img src="https://img.shields.io/badge/swift-5.9-orange.svg" />
    <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    <img src="https://img.shields.io/badge/platforms-macOS+iOS-brightgreen.svg?style=flat" alt="Mac + iOS" />
</p>

A framework for generating reports and other PDF documents with a SwiftUI like syntax.
##  Write page descriptions, not procedural code.
PDFBlocks provides an easy-to-use declarative language for describing document layout that is modeled after SwiftUI.
Here is the code used to generate the PDFBlocks logo used at the top of this document:

```swift
struct Logo: Block {
    var body: some Block {
        VStack(spacing: .pt(2)) {
            HStack(spacing: .pt(2)) {
                ForEach(data: ["P", "D", "F"]) {item  in
                    LetterBlock(letter: item, color: .red)
                }
            }
            HStack(spacing: .pt(2)) {
                ForEach(data: ["B", "L", "O", "C", "K", "S"]) {item  in
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
            .foregroundColor(.init(.white))
            .frame(width: .pt(48), height: .pt(48), alignment: .center)
            .background {
                color
            }
            .font(name: "American Typewriter", size: 36)
            .emphasized()
    }
}
```
## Configurable but easy to write reports.
The Table component takes advantage of Swift result builders, key paths, and format styles to allow you to create reports that
practically write themselves with autocomplete.
```swift
private struct TableExample: Block {    
    var body: some Block {
        Table(data: loadData(Data.self, from: customerData)) {
            TableColumn("Last Name", value: \.lastName, width: 20, alignment: .leading)
            TableColumn("First Name", value: \.firstName, width: 20, alignment: .leading)
            TableColumn("Address", value: \.address, width: 35, alignment: .leading)
            TableColumn("City", value: \.city, width: 25, alignment: .leading)
            TableColumn("State", value: \.state, width: 10, alignment: .leading)
            TableColumn("Zip", value: \.zip, width: 10, alignment: .leading)
            TableColumn("DOB", value: \.dob, format: .mmddyy, width: 10, alignment: .trailing)
        } groups: {
            TableGroup(on: \.state, order: <, spacing: .pt(12)) { rows, value in
                Text(stateName(abberviation: value))
                    .font(size: 14)
                    .emphasized()
            } footer: { rows, value in
                HLine()
                    .padding(vertical: .pt(2))
                Text("\(rows.count) records for \(stateName(abberviation: value))")
                    .emphasized()
                    .padding(leading: .max)
            }

        }
    }
}
```
<p align="center">
    <img src="Documentation/table-image.png" width="600" max-width="75%" alt=“Table Image” />
</p>

## Rendering Documents
To render a document from the preceeding code:
```swift
let data = Logo().renderPDF(pageSize: .letter, margins: .in(1))
```
## Installation

PDFBlocks is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/dkyowell/pdfblocks.git", from: "0.1.0-alpha")
    ],
    ...
)
```

Then import PDFBlocks wherever you’d like to use it:

```swift
import PDFBlocks
```
## For a Quick "Preview"
1. Download the PDFBlocks project.
2. Open Package.swift in XCode.
3. Navigate to Sources/PDFBlocks/Examples/Logo.swift.
4. Modify the sample files and see the results right away using Xcode Previews.

<p align="center">
    <img src="Documentation/xcode-preview.png" width="400" max-width="50%" alt=“Xcode Preview” />
</p>

## Constructing Documents
### Blocks
A Document is a Block. A Page is a Block. Text is a Block. Everything you will write in PDFBlocks is a Block 
composed of other blocks. For those familiar with SwiftUI, a Block is directly analagous to a View in SwiftUI.

Basic built-in blocks include Text, Image, Color, HLine, VStack, HStack, ZStack, Page, and Table. 
Built-in modifiers include Font, ForegroundColor, Opacity, Padding, Border, Frame, Background, and Overlay.

PDFBlocks is composable, so you can write your own reusable blocks like LetterBlock from the code sample above.

Those familiar with SwiftUI will already know how to code in PDFBlocks. Others can learn quickly by exploring
the example documents included with the package sourcecode.

### Pages
A document with multiple pages can be defined like this:
```swift
struct Document: Block {
    Page {
        ...
    }
    Page {
        ...
    }
}
let data = Document().renderPDF(pageSize: .letter, margins: .in(1))
```
A document with pages of differing sizes can be defined like this:
```swift
struct Document: Block {
    Page(size: .letter, margins: .in(1)) {
        ...
    }
    Page(size: .a4, margins: .mm(24)) {
        ...
    }
}
let data = Document().renderPDF()
```
## SwiftUI Inspired but not a Clone
### Units
Sizes need to be specified in points (.pt), inches (.in), or milimeters (.mm). 

### Alignment
Default alignment in SwiftUI is centered. In PDFBlocks it is top leading.

### Frames
There is no minWidth, maxWidth, minHeight, maxHeight for frames. Instead, a width or height can be set as .max.
So, instead of this from SwiftUI for positioning an element in the bottom trailing corner of a region:
```swift
Text("Hello, world)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
```
You would use:
```swift
Text("Hello, world)
    .frame(width: .max, height: .max, alignment: .bottomTrailing)
```
Even more intuitively, you could use:
```swift
Text("Hello, world)
    .padding(top: .max, leading: .max)
```

### Spacing
There is no Spacer block. Instead, stack spacing can be set as .flex. The following will give equal spacing between
elements:
```swift
HStack(spacing: .flex) {
    Text("One Fish")
    Text("Two Fish")
    Text("Red Fish")
    Text("Blue Fish")
}
```

## Usage Warnings
This is an early-release. The API is subject to change.

I advise against using San Francisco family fonts. These send the minimum PDF file size up to around 5MB. I do not know why.

## Contributions and Support
Open an issue with questions or feature requests.

See [Contributions.md](Contributions.md) for information about contributions.


