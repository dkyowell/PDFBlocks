/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// what is a way to repeat an entire page except for the repeatable part?

// PageWrap
//
// A VStack, Grid, or Table that allows PageWrap will take all proposed spaces.
// If a PageWrap is already within a PageWrap region, then it will take zero height.

// IDEA: allow overlay with multipage by pushing onto a stack.

// VStack, HGrid, and Table are page wrapping blocks that can layout their contents across multiple pages. VStack and
// HGrid opt into this behavior with the allowPageWrap: parameter; Tables are always page wrapping. The first page
// wrapping block encountered in a document will be the primary page wrapping block. The primary block will fill all
// of the space that it is alloted, even if it cannot fill that space. Any contents surrounding the primary block is
// considered to be a page frame and will be repeated on subsequent pages.
//
// When one page wrapping block is embedded within another, the embedded block is a secondary page wrapping block.
// A secondary block will be modified with a .frame, .border, .background, or .overlay. (A secondary page wrapping
// block reports itself as having zero height. I could put special handling in those modifiers, but at present they
// have no effect becuase of the zero height)
//
// Note: A non-wrapping VStack can be embedded within a wrapping VStack.
//
// Future work: allow a horizontal page wrap for horizontal overflow for VGrid, and HStack. This will require
// support within Context, but it should not be difficult.

// At present: .frame, .border, .background, .overlay cannot be applied upon

private struct Document: Block {
    var body: some Block {
        Page(size: .init(width: .in(6), height: .in(6)), margins: .in(1)) {
            PageNumberReader { pageNo in
                Text("Page \(pageNo)")
                    .padding(.bottom, .pt(CGFloat(pageNo * 12)))
            }
            .font(size: 36)
            .padding(.horizontal, .max)
            // .padding(.bottom, .pt(12))
            VStack(alignment: .center, allowWrap: true) {
                Text("A")
                Text("B")
                Text("C")
                    .scaleEffect(x: 4.0)
                HGrid(columnCount: 3, columnSpacing: 0, rowSpacing: 0, allowWrap: true) {
                    Group {
                        Text("D")
                        Text("E")
                        Text("F")
                        Text("G")
                        Text("H")
                        Text("I")
                        Text("J")
                        Text("K")
                        Text("L")
                        Text("M")
                        Text("N")
                        Text("O")
                        Text("N")
                        Text("O")
                        Text("N")
                        Text("O")
                        Text("N")
                        Text("O")
                        Text("P")
                        Text("Q")
                        Text("R")
                        Text("S")
                        Text("T")
                        Text("U")
                        Text("V")
                        Text("W")
                            .scaleEffect(3)
                    }
                }
                .opacity(0.25)
                .scaleEffect(3)
                .scaleEffect(3)
                .offset(x: 3, y: 3)
                .rotationEffect(.degrees(3))
                .aspectRatio(3)
                .border(.black)
                .background {
                    Color.red
                }
                .overlay {
                    Color.red
                }
                .frame(width: .in(1))
                .proportionalFrame(width: 0.5)
                Text("X")
                    .scaleEffect(3)
                Text("Y")
                Text("Z")
            }
            .scaleEffect(0.5)
            .padding(12)
            .overlay {
                Color.clear
                    .border(.blue, width: 12)
            }
            .font(size: 24)
            .padding(12)
            .rotationEffect(.degrees(10))
        }
        .background {
            Color.orange
        }
        .border(Color.black, width: 12)
        .font(name: "American Typewriter")
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
