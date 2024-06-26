/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

public struct ExampleTable: Block {
    let data: [CustomerData] = loadData(CustomerData.self, from: customerData)

    public init() {}
    
    public var body: some Block {
        Table(data) {
            TableColumn("Last Name", value: \.lastName, width: 20)
            TableColumn("First Name", value: \.firstName, width: 20)
            TableColumn("Address", value: \.address, width: 35)
            TableColumn("City", value: \.city, width: 25)
            TableColumn("State", value: \.state, width: 10, alignment: .trailing)
        }
    }
}

#Preview {
    previewForDocument(ExampleTable())
}
