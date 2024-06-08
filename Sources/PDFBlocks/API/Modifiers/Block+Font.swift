/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

public extension Block {
    func font(_ font: Font) -> some Block {
        environment(\.font, font)
    }

    func fontSize(_ size: CGFloat) -> some Block {
        environment(\.fontSize, size)
    }

    func fontName(_ name: String) -> some Block {
        environment(\.fontName, name)
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

    func fontFeature(_ feature: [KitFontDescriptor.FeatureKey: Int]) -> some Block {
        environment(\.fontFeature, feature)
    }
}

struct FontKey: EnvironmentKey {
    static let defaultValue: Font = .system(size: 12)
}

extension EnvironmentValues {
    var font: Font {
        get { self[FontKey.self] }
        set {
            self[FontKey.self].system = newValue.system
            if let name = newValue.name {
                self[FontKey.self].name = name
            }
            if let size = newValue.size {
                self[FontKey.self].size = size
            }
            if let weight = newValue.weight {
                self[FontKey.self].weight = weight
            }
            if let weight = newValue.weight {
                self[FontKey.self].weight = weight
            }
            if let width = newValue.width {
                self[FontKey.self].width = width
            }
            if let design = newValue.design {
                self[FontKey.self].design = design
            }
        }
    }
}

extension EnvironmentValues {
    var fontSize: CGFloat? {
        get {
            self[FontKey.self].size
        }
        set {
            self[FontKey.self].size = newValue
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

extension EnvironmentValues {
    var fontName: String? {
        get {
            self[FontKey.self].name
        }
        set {
            self[FontKey.self].name = newValue
        }
    }
}

struct FontFeatureKey: EnvironmentKey {
    static let defaultValue: [KitFontDescriptor.FeatureKey: Int] = [:]
}

extension EnvironmentValues {
    var fontFeature: [KitFontDescriptor.FeatureKey: Int] {
        get {
            self[FontFeatureKey.self]
        }
        set {
            self[FontFeatureKey.self] = newValue
        }
    }
}
