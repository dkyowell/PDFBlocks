/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Adds a background to this block with the specified content and alignment.
    ///
    /// - Parameter alignment: The alignment of the background content.
    /// - Parameter content: The background content.
    /// - Returns: A block that adds a background to this block.
    func background(alignment: Alignment = .center, @BlockBuilder _ content: () -> some Block) -> some Block {
        modifier(BackgroundModifier(background: content(), alignment: alignment))
    }

    /// Sets the block's background to a fill style.
    ///
    /// Use this modifier to place a type that conforms to the ``ShapeStyle``
    /// protocol --- like a ``Color``  or ``Gradient``  --- behind a view.
    /// For example, you can add a ``Color`` behind a ``Text``:
    ///
    ///     Text("The Quick Brown Fox")
    ///         .padding()
    ///         .background(.cyan)
    ///
    /// - Parameter style: An instance of a type that conforms to ``ShapeStyle`` that
    ///     will be drawn behind this block.
    /// - Returns: A block with the specified style drawn behind it.
    func background(_ style: some ShapeStyle) -> some Block {
        background {
            Rectangle()
                .fill(style)
        }
    }
}
