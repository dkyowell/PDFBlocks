/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

public struct ExampleColumns2: Block {
    let poem = "That time of year thou mayest in me behold, when yellow leaves or none or few do hang upon these boughs which shake against the cold, bare ruined choirs where late the sweet birds sang."
    public init() {}

    public var body: some Block {
        Page(size: .letter, margins: .in(1)) {
            VStack(spacing: .flex) {
                Columns(count: 2, spacing: 36) {
                    Text(poem)
                        .truncationMode(.wrap)
                        .fontSize(30)
                }
                HStack(spacing: .flex) {
                    Repeat(count: 18) {
                        Image(.init(systemName: "rhombus.fill"))
                            .frame(width: 6)
                    }
                }
                Columns(count: 3, spacing: 18) {
                    Text(poem)
                        .truncationMode(.wrap)
                        .fontSize(24)
                        .opacity(0.80)
                }
                HStack(spacing: .flex) {
                    Repeat(count: 18) {
                        Image(.init(systemName: "rhombus.fill"))
                            .frame(width: 6)
                    }
                }
                Columns(count: 4, spacing: 12) {
                    Text(poem)
                        .truncationMode(.wrap)
                        .fontSize(18)
                        .opacity(0.60)
                }
            }
        }
        .italic()
        .fontDesign(.serif)
        .border(Color.black, width: 8)
    }
}

#Preview {
    previewForDocument(ExampleColumns2())
}
