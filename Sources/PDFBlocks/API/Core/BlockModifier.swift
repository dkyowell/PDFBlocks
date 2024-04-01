/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public protocol BlockModifier {
    typealias Content = _BlockModifier_Content<Self>

    /// The type of view representing the body.
    associatedtype Body: Block
    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    @BlockBuilder func body(content: Content) -> Self.Body
    /// The content view type passed to `body()`.
    ///
}

public struct _BlockModifier_Content<Modifier: BlockModifier>: Block {
    public init(modifier: Modifier, block: AnyBlock) {
        self.modifier = modifier
        self.block = block
    }

    let modifier: Modifier
    let block: AnyBlock

    public init(modifier: Modifier, block: some Block) {
        self.modifier = modifier
        self.block = AnyBlock(block)
    }

    public var body: some Block {
        block
    }
}

public struct ModifiedContent<Content, Modifier> {
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }

    var content: Content
    var modifier: Modifier
}

extension ModifiedContent: Block where Content: Block, Modifier: BlockModifier {
    public var body: Never {
        fatalError()
    }
}

public extension Block {
    func modifier<Modifier>(_ modifier: Modifier) -> ModifiedContent<Self, Modifier> {
        ModifiedContent(content: self, modifier: modifier)
    }
}
