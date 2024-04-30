/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

#if os(iOS)
    import UIKit
#endif
#if os(macOS)
    import AppKit
#endif

public struct Font {
    public typealias Weight = KitFont.Weight
    public typealias Design = KitFontDescriptor.SystemDesign
    public typealias Width = KitFont.Width

    var kitFont: KitFont
    var weight: Weight?
    var design: Design?
    var width: Width?
}

public extension Font {
    init(_ font: KitFont?) {
        kitFont = font ?? KitFont.systemFont(ofSize: 12)
    }

    static func system(size: CGFloat, weight: Weight? = nil, design: Design? = nil) -> Font {
        Font(kitFont: .systemFont(ofSize: size), weight: weight, design: design)
    }
}

extension Font {
    func resolvedFont(environment: EnvironmentValues) -> KitFont {
        // Apply Font.Width
        var descriptor: KitFontDescriptor = if kitFont.isSystemFont {
            KitFont.systemFont(ofSize: kitFont.pointSize, weight: .regular, width: width ?? .standard)
                .fontDescriptor
        } else {
            KitFontDescriptor()
                .withSize(kitFont.pointSize)
                .withFamily(kitFont.familyName)
        }
        // Apply Font.Design
        descriptor = descriptor.withDesign(design ?? .default) ?? descriptor
        // Apply Font.Weight
        var traits = [KitFontDescriptor.TraitKey: Any]()
        traits[KitFontDescriptor.TraitKey.weight] = weight ?? .regular
        let attributes: [KitFontDescriptor.AttributeName: Any] = [.traits: traits]
        descriptor = descriptor.addingAttributes(attributes)
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
        #endif
        #if os(macOS)
            if environment.italic, environment.bold {
                descriptor = descriptor.withSymbolicTraits([.italic, .bold])
            } else if environment.italic {
                descriptor = descriptor.withSymbolicTraits([.italic])
            } else if environment.bold {
                descriptor = descriptor.withSymbolicTraits([.bold])
            }
            let interim = KitFont(descriptor: descriptor, size: 0) ?? kitFont
        #endif
        return interim
    }
}

extension KitFont {
    var isSystemFont: Bool {
        familyName == KitFont.systemFont(ofSize: 14).familyName
    }
}
