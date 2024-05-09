/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks

private struct Document: Block {
    let data: [CustomerData]

    var body: some Block {
        Table(data) {
            TableColumn("Last Name", value: \.lastName, width: 20)
            TableColumn("First Name", value: \.firstName, width: 20)
            TableColumn("Address", value: \.address, width: 35)
            TableColumn("City", value: \.city, width: 25)
            TableColumn("State", value: \.state, width: 10)
            TableColumn("Zip", value: \.zip, width: 10)
            TableColumn("DOB", value: \.dob, format: .mmddyy, width: 10, alignment: .trailing)
        } pageHeader: { _ in
            TableColumnTitles()
        }
        .font(.system(size: 9))
        .padding(bottom: .max, trailing: .max)
        .fontWidth(.condensed)
    }
}

import PDFKit

#Preview {
    print("\n\n>>>>")
    let view = PDFView()
    view.autoScales = true
    Task {
        if let data = try? await Document(data: loadData(CustomerData.self, from: customerData))
            .renderPDF(size: .letter, margins: .init(.in(1)))
        {
            view.document = PDFDocument(data: data)
        }
    }
    return view
}
