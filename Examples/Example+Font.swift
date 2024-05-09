/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

private struct Document: Block {
    var body: some Block {
        Page(size: .init(width: .in(4), height: .in(6)), margins: .in(0.5)) {
            HStack(spacing: 12) {
                VStack(spacing: 12) {
                    VStack(alignment: .center) {
                        // Color.cyan.opacity(0.25)
                        Text("One Fish")
                            .fontWeight(.ultraLight)
                        Text("One Fish")
                            .fontWeight(.thin)
                        Text("One Fish")
                            .fontWeight(.light)
                        Text("One Fish")
                            .fontWeight(.regular)
                        Text("One Fish")
                            .fontWeight(.medium)
                        Text("One Fish")
                            .fontWeight(.semibold)
                        Text("One Fish")
                            .fontWeight(.heavy)
                        Text("One Fish")
                            .fontWeight(.black)
                    }
                    .fontDesign(.default)
                    VStack(alignment: .center) {
                        // Color.cyan.opacity(0.25)
                        Text("One Fish")
                            .fontWeight(.ultraLight)
                        Text("One Fish")
                            .fontWeight(.thin)
                        Text("One Fish")
                            .fontWeight(.light)
                        Text("One Fish")
                            .fontWeight(.regular)
                        Text("One Fish")
                            .fontWeight(.medium)
                        Text("One Fish")
                            .fontWeight(.semibold)
                        Text("One Fish")
                            .fontWeight(.heavy)
                        Text("One Fish")
                            .fontWeight(.black)
                    }
                    .fontDesign(.rounded)
                }
                VStack(spacing: 12) {
                    VStack(alignment: .center) {
                        // Color.cyan.opacity(0.25)
                        Text("One Fish")
                            .fontWeight(.ultraLight)
                        Text("One Fish")
                            .fontWeight(.thin)
                        Text("One Fish")
                            .fontWeight(.light)
                        Text("One Fish")
                            .fontWeight(.regular)
                        Text("One Fish")
                            .fontWeight(.medium)
                        Text("One Fish")
                            .fontWeight(.semibold)
                        Text("One Fish")
                            .fontWeight(.heavy)
                        Text("One Fish")
                            .fontWeight(.black)
                    }
                    .fontDesign(.serif)
                    VStack(alignment: .center) {
                        // Color.cyan.opacity(0.25)
                        Text("One Fish")
                            .fontWeight(.ultraLight)
                        Text("One Fish")
                            .fontWeight(.thin)
                        Text("One Fish")
                            .fontWeight(.light)
                        Text("One Fish")
                            .fontWeight(.regular)
                        Text("One Fish")
                            .fontWeight(.medium)
                        Text("One Fish")
                            .fontWeight(.semibold)
                        Text("One Fish")
                            .fontWeight(.heavy)
                        Text("One Fish")
                            .fontWeight(.black)
                    }
                    .fontDesign(.monospaced)
                }
            }
            .font(.system(size: 18))
        }
        .border(.black, width: 4)
    }
}

#Preview {
    let view = PDFView()
    view.autoScales = true
    Task {
        if let data = try? await Document().renderPDF() {
            view.document = PDFDocument(data: data)
        }
    }
    return view
}
