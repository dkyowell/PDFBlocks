<p align="left">
    <img src="Documentation/logo.png" width="300" max-width="50%" alt=“PDFBlocks” />
</p>
<p align="left">
    <img src="https://img.shields.io/badge/swift-5.9-orange.svg" />
    <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    <img src="https://img.shields.io/badge/platforms-macOS+iOS-brightgreen.svg?style=flat" alt="Mac + iOS" />
</p>

PDFBlocks is a powerful but easy to use PDF document and report generation library written in Swift for Apple platforms. Inspired by SwiftUI, it allows documents to be expressed with a declarative syntax. You just declare what you want printed within appropriate layout structures, and PDFBlocks takes care of positioning, pagination, and all the rest.

## Sample Documents. 

These sample documents and accompanying code provide examples of some of some of the layout capabilities of PDFBlocks.

<table>
  <tr>
     <th>Columns</th>
     <th>Stack Layout</th>
     <th>Report</th>
  </tr>
  <tr>
     <td><a href="Documentation/example-columns.pdf"><img src="Documentation/example-columns.jpg" width="300" max-width="33%" alt=“Columns Example”/></a></td>
     <td><a href="Documentation/example-stacks.pdf"><img src="Documentation/example-stacks.jpg" width="300" max-width="33%" alt=“Stacks Example”/></a></td>
     <td><a href="Documentation/example-report.pdf"><img src="Documentation/example-report.jpg" width="300" max-width="33%" alt=“Report Example”/></a></td>
  </tr>
  <tr>
     <th><a href="Documentation/example-columns.md">Code</a></th>
     <th><a href="Documentation/example-stacks.md">Code</a></th>
     <th><a href="Documentation/example-report.md">Code</a></th>
  </tr>
</table>
<table>

  <tr>
     <th>Vector Drawing</th>
     <th>Gradient Fill</th>
     <th>Custom Components</th>
  </tr>
  <tr>
     <td><a href="Documentation/example-vector.pdf"><img src="Documentation/example-vector.jpg" width="300" alt=“PDFBlocks”/></a></td>
     <td><a href="Documentation/example-gradient.pdf"><img src="Documentation/example-gradient.jpg" width="300" alt=“PDFBlocks”/></a></td>
     <td><a href="Documentation/example-custom.pdf"><img src="Documentation/example-custom.jpg" width="300" alt=“PDFBlocks”/></a></td>
  </tr>
  <tr>
     <th><a href="Documentation/example-vector.md">Code</a></th>
     <th><a href="Documentation/example-gradient.md">Code</a></th>
     <th><a href="Documentation/example-custom.md">Code</a></th>
  </tr>
</table>


## Live Previews
PDFBlocks works very well with Xcode Previews. Instantly see your document rendered as a PDF as you code.

<p align="center">
    <img src="Documentation/xcode-preview.png" width="400" max-width="50%" alt=“Xcode Preview” />
</p>


Xcode Previews ia also a great way to get a quick start with PDFBlocks before installing it into your own project.

1. Download the PDFBlocks project.
2. Open Package.swift in Xcode.
3. Navigate to Examples directory
4. Select scheme PDFBlocks-Package or PDFBlocksExamples
4. Puruse the example documents. Modify them if you wish and see the results within Xcode.


## Documentation
[Documentation.md](Documentation/Documentation.md)



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

## Roadmap
[Roadmap.md](Documentation/Roadmap.md)

## Beta Release
This is a beta release. The API and layout heuristics could change up until the 1.0 release.

## Support
Open an issue with questions or feature requests. I am actively developing this project and will try to accomodate requests that fit within the goals of the project. You can also send me an email at dkyowell.opensource@gmail.com.
