/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFKit

private struct Document: Block {
    let poem = "That time of year thou mayest in me behold, when yellow leaves or none or few do hang upon these boughs which shake against the cold, bare ruined choirs where late the sweet birds sang."
    var body: some Block {
        Page(size: .init(width: .in(6), height: .in(6)), margins: .in(0.5)) {
            VStack(spacing: .flex) {
                Columns(count: 2, spacing: 12, pageWrap: false) {
                    Text(poem)
                        .font(size: 20)
                        .rotationEffect(.degrees(5))
                }
                Line(start: .leading, end: .trailing)
                    .stroke(.gray, style: StrokeStyle(lineWidth: .pt(3), lineCap: .round, dash: [0, 16]))
                    .frame(height: 0)
                    .padding(.horizontal, 43)
                    .rotationEffect(.degrees(-5))
                Columns(count: 3, spacing: 6, pageWrap: false) {
                    Text(poem)
                        .font(size: 16)
                        .opacity(0.80)
                        .rotationEffect(.degrees(5))
                }
                Line(start: .leading, end: .trailing)
                    .stroke(.gray, style: StrokeStyle(lineWidth: .pt(3), lineCap: .round, dash: [0, 16]))
                    .frame(height: 0)
                    .padding(.horizontal, 43)
                    .rotationEffect(.degrees(-5))
                Columns(count: 4, spacing: 6, pageWrap: false) {
                    Text(poem)
                        .font(size: 12)
                        .opacity(0.60)
                        .rotationEffect(.degrees(5))
                }
            }
        }
        .italic()
        .fontDesign(.serif)
        .border(Color.black, width: 4)
    }
}

#Preview {
    print("\n>>>>")
    let view = PDFView()
    view.autoScales = true
    Task {
        if let data = try? await Document().renderPDF() {
            view.document = PDFDocument(data: data)
        }
    }
    return view
}
