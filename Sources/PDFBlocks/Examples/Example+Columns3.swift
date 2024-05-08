/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFKit

public struct Columns3Example: Block {
    public var body: some Block {
        Columns(count: 2, spacing: 24, pageWrap: true) {
            Text(text)
            VStack(spacing: 24, pageWrap: true) {
                Repeat(count: 10) {
                    Text("Hello")
                        .padding(.horizontal, .max)
                        .padding(.vertical, 4)
                    Image(.init(systemName: "globe"))
                        .padding(.horizontal, .max)
                }
            }
        }
        .fontSize(20)
        .fontDesign(.serif)
    }

    public init() {}
}

#Preview {
    print("\n>>>")
    let view = PDFView()
    view.autoScales = true
    Task {
        if let data = try? await Columns3Example().renderPDF() {
            view.document = PDFDocument(data: data)
        }
    }
    return view
}

private let text =
    """
    Praesent dapibus neque id cursus faucibus tortor neque egestas auguae eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi tincidunt quis accumsan porttitor facilisis luctus metus. Phasellus ultrices nulla quis nibh. Quisque a lectus. Donec consectetuer ligula vulputate sem tristique cursus. Nam nulla quam gravida non commodo a sodales sit amet nisi.

    Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non semper suscipit posuere a pede.Donec nec justo eget felis facilisis fermentum. Aliquam porttitor mauris sit amet orci. Aenean dignissim pellentesque felis.

    Praesent dapibus neque id cursus faucibus tortor neque egestas auguae eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi tincidunt quis accumsan porttitor facilisis luctus metus. Phasellus ultrices nulla quis nibh. Quisque a lectus. Donec consectetuer ligula vulputate sem tristique cursus. Nam nulla quam gravida non commodo a sodales sit amet nisi.
    """
