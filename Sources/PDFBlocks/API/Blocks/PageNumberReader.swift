/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that provides its content with the current page number.
public struct PageNumberReader<Content>: Block where Content: Block {
    let content: (Int) -> Content

    init(@BlockBuilder content: @escaping (Int) -> Content) {
        self.content = content
    }
}
