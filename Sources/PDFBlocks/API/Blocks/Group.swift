/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that collects multiple subblocks into a single unit.
///
/// A modifier can be applied to multiple blocks at once in
/// this manner:
///
///      Group {
///          Text("Quick")
///          Text("Brown")
///          Text("Fox")
///      }
///      .fontSize(18)
///
public struct Group<Content>: Block where Content: Block {
    let content: Content

    public init(@BlockBuilder content: () -> Content) {
        self.content = content()
    }
}
