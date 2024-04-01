/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    /// Adds padding to this block..
    func padding(_ padding: EdgeInsets) -> some Block {
        modifier(PaddingModifier(padding: padding))
    }

    /// Adds padding to this block..
    func padding(top: Size = .pt(0), leading: Size = .pt(0), bottom: Size = .pt(0), trailing: Size = .pt(0)) -> some Block {
        padding(.init(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }

    /// Adds padding to this block..
    func padding(bottom: Size) -> some Block {
        padding(.init(bottom: bottom))
    }

    /// Adds padding to this block..
    func padding(top: Size) -> some Block {
        padding(.init(top: top))
    }

    /// Adds padding to this block..
    func padding(leading: Size) -> some Block {
        padding(.init(leading: leading))
    }

    /// Adds padding to this block..
    func padding(trailing: Size) -> some Block {
        padding(.init(trailing: trailing))
    }

    /// Adds padding to this block..
    func padding(horizontal: Size) -> some Block {
        padding(.init(top: .pt(0), leading: horizontal, bottom: .pt(0), trailing: horizontal))
    }

    /// Adds padding to this block..
    func padding(vertical: Size) -> some Block {
        padding(.init(top: vertical, leading: .pt(0), bottom: vertical, trailing: .pt(0)))
    }
}
