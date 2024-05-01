/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that occupies no space and renders no content.
///
/// NOTE: EmptyView in SwiftUI is a special view that really does
/// indicate the absence of a view. For instance, .onAppear {}
/// will ever be executed on an EmptyView. EmptyBlock on the
/// other hand has no special semantics. It is simply a view that
/// takes no space and renders nothing.
public struct EmptyBlock: Block {
    /// Creates an instance..
    public init() {}
}
