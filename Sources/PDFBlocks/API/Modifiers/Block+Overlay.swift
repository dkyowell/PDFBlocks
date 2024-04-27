/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Adds a overlay to this block with the specified content and alignment.
    ///
    /// - Parameter alignment: The alignment of the overlay content.
    /// - Parameter content: The overlay content.
    /// - Returns: A block that adds an overlay to this block.
    func overlay(alignment: Alignment = .center, @BlockBuilder _ content: () -> some Block) -> some Block {
        modifier(OverlayModifier(overlay: content(), alignment: alignment))
    }

    /// Sets the block's overlay to a fill style.
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
    ///     will be drawn on top of this block.
    /// - Returns: A block with the specified style drawn on top of it.
    func overlay(_ style: some ShapeStyle) -> some Block {
        overlay {
            Rectangle()
                .fill(style)
        }
    }
}
