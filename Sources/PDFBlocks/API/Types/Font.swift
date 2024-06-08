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

public struct Font {
    public typealias Weight = KitFont.Weight
    public typealias Design = KitFontDescriptor.SystemDesign
    public typealias Width = KitFont.Width

    var system: Bool
    var name: String?
    var size: CGFloat?
    var weight: Weight?
    var design: Design?
    var width: Width?
}

public extension Font {
    init(name: String, size: CGFloat, weight: Weight? = nil, design: Design? = nil) {
        system = false
        self.name = name
        self.size = size
        self.weight = weight
        self.design = design
        width = nil
    }

    init(_ font: KitFont?) {
        system = false
        name = font?.familyName
        size = font?.pointSize
    }

    static func system(size: CGFloat, weight: Weight? = nil, design: Design? = nil) -> Font {
        Font(system: true, name: nil, size: size, weight: weight, design: design)
    }
}

extension Font {
    func resolvedFont(environment: EnvironmentValues) -> KitFont {
        // Apply Font.Width
        var descriptor: KitFontDescriptor = if system {
            KitFont.systemFont(ofSize: size ?? environment.font.size ?? 12, weight: weight ?? .regular, width: width ?? .standard)
                .fontDescriptor
        } else {
            KitFontDescriptor()
                .withSize(size ?? environment.font.size ?? 12)
            #if os(iOS)
                .withFamily(name ?? "")
            #else
                .withFamily(name ?? "")
            #endif
        }
        // Apply Font.Design
        descriptor = descriptor.withDesign(design ?? .default) ?? descriptor
        // Apply Font.Weight
        var traits = [KitFontDescriptor.TraitKey: Any]()
        traits[KitFontDescriptor.TraitKey.weight] = weight
        let attributes: [KitFontDescriptor.AttributeName: Any] = [.traits: traits]
        descriptor = descriptor.addingAttributes(attributes)
        // Apply Font Feature
        descriptor = descriptor.addingAttributes([.featureSettings: [environment.fontFeature]])
        // Apply Bold and Italic
        #if os(iOS)
            if environment.italic, environment.bold {
                descriptor = descriptor.withSymbolicTraits([.traitItalic, .traitBold]) ??
                    descriptor.withSymbolicTraits([.traitItalic]) ??
                    descriptor.withSymbolicTraits([.traitBold]) ?? descriptor
            } else if environment.italic {
                descriptor = descriptor.withSymbolicTraits([.traitItalic]) ?? descriptor
            } else if environment.bold {
                descriptor = descriptor.withSymbolicTraits([.traitBold]) ?? descriptor
            }
            let interim = KitFont(descriptor: descriptor, size: 0)
        #else
            if environment.italic, environment.bold {
                descriptor = descriptor.withSymbolicTraits([.italic, .bold])
            } else if environment.italic {
                descriptor = descriptor.withSymbolicTraits([.italic])
            } else if environment.bold {
                descriptor = descriptor.withSymbolicTraits([.bold])
            }
            let interim = KitFont(descriptor: descriptor, size: 0) ?? .systemFont(ofSize: 12)
        #endif
        return interim
    }
}

extension KitFont {
    var isSystemFont: Bool {
        familyName == KitFont.systemFont(ofSize: 14).familyName
    }
}
