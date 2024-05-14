/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

// In general, a
public struct ExampleColumns3: Block {
    public var body: some Block {
        Columns(count: 2, spacing: 24, wrapContents: true) {
            VStack(spacing: .flex, wrapContents: false) {
                Repeat(count: 20) {
                    Text("Text")
                        .padding(.horizontal, .max)
                        .opacity(0.25)
                }
            }
            .border(.orange)
            .fontWeight(.black)
            .fontSize(48)
            VStack(spacing: .flex, wrapContents: false) {
                Repeat(count: 20) {
                    Text("Text")
                        .padding(.horizontal, .max)
                        .opacity(0.25)
                }
            }
            .border(.orange)
            .fontWeight(.black)
            .fontSize(48)
            VStack(wrapContents: false) {
                Repeat(count: 1) {
                    Color.blue
                    Color.red
                    Color.purple
                    Color.green
                }
            }
            VStack(wrapContents: false) {
                Repeat(count: 1) {
                    Color.blue
                    Color.red
                    Color.purple
                    Color.green
                }
            }


//            VStack(spacing: 20, wrapContents: true) {
//                Repeat(count: 5) {
//                    Text("Some text")
//                }
//                Color.purple
//                VStack {
//                    Text("One")
//                    Color.blue
//                    Text("Fish")
//                    Color.red
//                    Text("Two")
//                    Color.blue
//                    Text("Fish")
//                }
//                VStack {
//                    Text("One")
//                    Color.blue
//                    Text("Fish")
//                    Color.red
//                    Text("Two")
//                    Color.blue
//                    Text("Fish")
//                }
//                Text("OK")
//                    .padding(.horizontal, .max)
//                Text("OK")
//                Text("OK")
//                Text("OK")
//            }
        }
        .fontSize(20)
        .fontDesign(.serif)
    }

    public init() {}
}

#Preview {
    previewForDocument(ExampleColumns3())
}

private let text =
    """
    Praesent dapibus neque id cursus faucibus tortor neque egestas auguae eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi tincidunt quis accumsan porttitor facilisis luctus metus. Phasellus ultrices nulla quis nibh. Quisque a lectus. Donec consectetuer ligula vulputate sem tristique cursus. Nam nulla quam gravida non commodo a sodales sit amet nisi.

    Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non semper suscipit posuere a pede.Donec nec justo eget felis facilisis fermentum. Aliquam porttitor mauris sit amet orci. Aenean dignissim pellentesque felis.

    Praesent dapibus neque id cursus faucibus tortor neque egestas auguae eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi tincidunt quis accumsan porttitor facilisis luctus metus. Phasellus ultrices nulla quis nibh. Quisque a lectus. Donec consectetuer ligula vulputate sem tristique cursus. Nam nulla quam gravida non commodo a sodales sit amet nisi.
    """
