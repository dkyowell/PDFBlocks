/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A padded line, drawn vertically in an `HStack`
/// and horizontally in a `VStack`.
public struct Divider: Block {
    let thickness: Dimension
    let padding: Dimension

    @Environment(\.layoutAxis) var layoutAxis

    /// Creates an instance with the given parameters..
    ///
    /// - Parameters:
    ///   - thickness: The thickness of the line.
    ///   - padding: The padding on either side of the line.
    public init(thickness: Dimension = .pt(0.75), padding: Dimension = .pt(1)) {
        self.thickness = thickness
        self.padding = padding
    }

    public var body: some Block {
        switch layoutAxis {
        case .horizontal:
            Line(start: .top, end: .bottom)
                .frame(width: thickness)
                .padding(.horizontal, padding)
                .stroke(.black)
        case .vertical, .undefined:
            Line(start: .leading, end: .trailing)
                .frame(height: thickness)
                .padding(.vertical, padding)
                .stroke(.black)
        }
    }
}
