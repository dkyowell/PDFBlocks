/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

struct ErrorMessageBlock: Block {
    let message: String

    var body: some Block {
        Text("ERROR: \(message)")
            .font(size: 18)
            .padding(top: .pt(3))
            .padding(.pt(4))
            .border(color: .red, width: .pt(1))
            .foregroundColor(.red)
    }
}
