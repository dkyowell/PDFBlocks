/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

#if os(macOS)
    import AppKit

    extension NSColor: PlatformColor {
        public func opacity(value: CGFloat) -> PlatformColor {
            withAlphaComponent(value * cgColor.alpha)
        }
    }

    public extension Color {
        init(_ color: NSColor) {
            platformColor = color
        }
    }

    public extension Color {
        static var clear: Color {
            .init(NSColor.clear)
        }

        static var blue: Color {
            .init(NSColor.systemBlue)
        }

        static var red: Color {
            .init(NSColor.systemRed)
        }

        static var green: Color {
            .init(NSColor.systemGreen)
        }

        static var yellow: Color {
            .init(NSColor.systemYellow)
        }

        static var orange: Color {
            .init(NSColor.systemOrange)
        }

        static var purple: Color {
            .init(NSColor.systemPurple)
        }

        static var pink: Color {
            .init(NSColor.systemPink)
        }

        static var cyan: Color {
            .init(NSColor.systemCyan)
        }

        static var gray: Color {
            .init(NSColor.gray)
        }

        static var white: Color {
            .init(NSColor.white)
        }

        static var black: Color {
            .init(NSColor.black)
        }
    }

    extension NSImage: PlatformImage {}

    public extension Image {
        init(_ image: NSImage?) {
            self.image = image ?? KitImage()
        }

        init(path: String) {
            image = NSImage(contentsOfFile: path) ?? KitImage()
        }
    }

    public extension NSImage {
        convenience init?(systemName: String) {
            self.init(systemSymbolName: systemName, accessibilityDescription: nil)
        }
    }
#endif
