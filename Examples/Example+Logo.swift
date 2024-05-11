/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

public struct ExampleLogo: Block {
    public init() {}

    public var body: some Block {
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
            .frame(width: 84, height: 84, alignment: .center)
            .background(color)
            .font(.init(.init(name: "American Typewriter", size: 68)))
            .bold()
    }
}

#Preview {
    previewForDocument(ExampleLogo())
}
