/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

public extension Block {
    func font(size: CGFloat) -> some Block {
        environment(\.fontSize, size)
    }

    func fontWeight(_ weight: Font.Weight) -> some Block {
        environment(\.fontWeight, weight)
    }

    func fontDesign(_ design: Font.Design) -> some Block {
        environment(\.fontDesign, design)
    }

    func fontWidth(_ width: Font.Width) -> some Block {
        environment(\.fontWidth, width)
    }

    func font(_ font: Font) -> some Block {
        environment(\.font, font)
    }

    func kerning(_ kerning: CGFloat) -> some Block {
        environment(\.kerning, kerning)
    }
}

struct FontKey: EnvironmentKey {
    static let defaultValue: Font = .init(kitFont: .systemFont(ofSize: 12), weight: .regular)
}

extension EnvironmentValues {
    var font: Font {
        get { self[FontKey.self] }
        set {
            self[FontKey.self].kitFont = newValue.kitFont
            if let design = newValue.design {
                self[FontKey.self].design = design
            }
        }
    }
}

extension EnvironmentValues {
    var fontSize: CGFloat {
        get {
            self[FontKey.self].kitFont.pointSize
        }
        set {
            let font = self[FontKey.self]
            let newFont = font.kitFont.withSize(newValue)
            self[FontKey.self] = .init(kitFont: newFont, weight: font.weight, design: font.design, width: font.width)
        }
    }
}

extension EnvironmentValues {
    var fontWeight: KitFont.Weight? {
        get {
            self[FontKey.self].weight
        }
        set {
            self[FontKey.self].weight = newValue
        }
    }
}

extension EnvironmentValues {
    var fontWidth: KitFont.Width? {
        get {
            self[FontKey.self].width
        }
        set {
            self[FontKey.self].width = newValue
        }
    }
}

extension EnvironmentValues {
    var fontDesign: KitFontDescriptor.SystemDesign? {
        get {
            self[FontKey.self].design
        }
        set {
            self[FontKey.self].design = newValue
        }
    }
}

struct KerningKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    var kerning: CGFloat {
        get {
            self[KerningKey.self]
        }
        set {
            self[KerningKey.self] = newValue
        }
    }
}
