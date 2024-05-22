# Documentation

## Basics

### Blocks
A `Block` in PDFBlocks is equivalent to a `View` in SwiftUI.

### Units
The default unit in PDFBlocks is a typographic point (1/72 inch), but you may also use inches or mm. The following are are equivalent:
```swift
Text("Hello, world.")
  .padding(72)
Text("Hello, world.")
  .padding(.in(1))
Text("Hello, world.")
  .padding(.mm(25.4))
Text("Hello, world.")
  .padding(.pt(72))
```

### Rendering
Rendering is a simple as called `.render()` on a `Block` that you have defined. A `Data` is returned which 
can be used to display, save to storage, send over the network, etc.
```swift
struct Document: Block {
    var body: some Block {
      ...
    }
}

let data = Document().render()
```

## Multipage Components 
`VStack`, `VGrid`, and `Columns` are components that can allow their content to start a new column or page by setting the `wrapping` parameter to true.

```swift
Columns(count: 2, spacing: 36, wrapping: true) {
  Text("Four score and seventy years ago...")
}
```
Note: `.flex` spacing does not work within a page wrap block. 

### Page Headers and Footers
Page headers and footers can be expressed simply by surrounding a page wrap block with a `VStack`. The first page wrap block encountered will take all of the space on the page that it can. Content that surrounds the first page wrap block will be repeated on every page. 
```swift
VStack {
  Text("This text will repeat at the top of each page.")
  Columns(count: 2, spacing: 36, wrapping: true) {
    Text("Four score and seventy years ago...")
  }
  Text("This text will repeat at the bottom of each page.")
}
```
You are not limited to page headers and footers, you could change the `VStack` to an `HStack` in the preceeding example and have a page "leader" and page "trailer". 
### Page Numbers
`PageNumberReader` is a component that provides the current page number and optionally the total page count. Computing the page count is optional because it will roughly double the amount of time required to generate a PDF. Here, the page number is printed as a page header, but is supressed on the first page.

```swift
VStack {
  PageNumberReader(computePageCount: true) { proxy in
    if pageNo > 0 {
      Text("Page \(proxy.pageNo) of \(proxy.pageCount)")
        .padding(.horizontal, .max)
        .padding(.bottom, 36)
    }
  }
  Columns(count: 2, spacing: 36, wrapping: true) {
    Text(...)
  }
}
```

### Pages
You can optionally define one or more pages as part of your document. Pages can be different sizes within one document.
```swift
struct Document: Block {
    var body: some Block {
      Page(size: .letter, margins: .in(1)) {
          ...
      }
      Page(size: .a4, margins: .mm(24)) {
          ...
      }
    }
}

let data = Document().render()
```
If you do not define a page within your document, then you can supply a size and margins as part of the render call. (If you
provide neither, it will fall back to a default of US Letter page size.)

```swift
Document().renderPDF(size: .letter, margins: .init(.in(1)))
```

## Platforms
PDFBlocks can be used in AppKit, UIKit, SwiftUI, or even Mac console applications. While inspired by SwiftUI, PDFBlocks itself does not have any SwiftUI dependencies.

## API
PDFBlocks follows SwiftUI syntax closely. Much of the SwiftUI API has been implemented, but this is by no means
an exhaustive clone. The following is the list of what has been implemented so far. Items marked with an * are
PDFBlocks constructs that are not in SwiftUI.


### Container Blocks
* HStack
* VStack
* ZStack
* Columns* - A container like a multi-column VStack. A Text can wrap from one column to another.
* VGrid
* Page* 
* Table - A very powerful data aware container for producing columnular reports with page headers/footers and automatic data grouping.

### Primitive Blocks
* Divider
* Image - Images are resizable by default and always maintain their native aspect ratio.
* Line* - Draws a line within a rectangular area.
* Shape
* Spacer
* Text

### Group Blocks
* ForEach
* Group
* Repeat* - Repeat a block n number of times.

### Reader Blocks
* PageNumberReader* - This is similiar to a GeometryReader, except that it provides the current page number for printing purposes.

### Composite Blocks
You can write your own re-usable composite blocks using any of PDFBlocks' built in blocks and modifiers.

### Shapes
* Capsule
* Circle
* Ellipse
* Rectangle
* RoundedRectangle
* Square*

### ShapeStyles
* Color
* LinearGradient
* RadialGradient

### Modifiers
* aspectRatio
* background
* bold
* border
* environment
* fill
* font
* fontDesign
* fontSize
* fontWeight
* fontWidth
* foregroundColor
* foregroundStyle
* frame - At present, there is no .minWidth/Height, .maxWidth/Height, or .idealWidth/Height. A new feature of PDFBlocks, padding(.max), can alleviate much of the need for frames. 
* italic
* kerning
* mutlilineTextAlignment - At present, there is no .justified mode.
* offset
* onRender
* opacity
* overlay
* padding - Padding can be specified as `.max`. So, instead of `.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)`, you can use         `.padding(bottom: .max, trailing: .max)`.

* proportionalFrame*
* rotationEffect
* stroke
* textFill* 
* textStroke*
* truncationMode
* scaleEffect

## Issues
Right-to-left language support has not yet been implemented.
