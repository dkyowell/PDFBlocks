/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// GroupBlocks are a special class of blocks that do not render themselves, but instead supply
// their content as an array of blocks for other blocks such as VStack or HStack to layout and
// render.

protocol GroupBlock {
    var blocks: [any Block] { get }
}

extension GroupBlock {
    public var body: Never {
        fatalError()
    }
}

extension GroupBlock {
    // Returns a recursively flattened array of a GroupBlock's blocks. Blocks #1 and #2
    // are senamtically the same.

    // #1
    // Group {
    //   Text("1")
    //   Group {
    //     Text("2")
    //     Text("3")
    //   }
    // }

    // #2
    // Group {
    //   Text("1")
    //   Text("2")
    //   Text("3")
    // }
    func flattenedBlocks() -> [any Block] {
        blocks.reduce([]) { partialResult, block in
            if let cast = block as? GroupBlock {
                partialResult + cast.flattenedBlocks()
            } else {
                partialResult + [block]
            }
        }
    }
}
