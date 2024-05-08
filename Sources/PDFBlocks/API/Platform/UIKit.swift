/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

#if os(iOS)
    import UIKit

    extension UIColor: PlatformColor {
        public func opacity(value: CGFloat) -> PlatformColor {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return withAlphaComponent(value * alpha)
        }
    }

    public extension Color {
        init(_ color: UIColor) {
            platformColor = color
        }
    }

    public extension Color {
        static var clear: Color {
            .init(UIColor.clear)
        }

        static var blue: Color {
            .init(UIColor.systemBlue)
        }

        static var red: Color {
            .init(UIColor.systemRed)
        }

        static var green: Color {
            .init(UIColor.systemGreen)
        }

        static var yellow: Color {
            .init(UIColor.systemYellow)
        }

        static var orange: Color {
            .init(UIColor.systemOrange)
        }

        static var purple: Color {
            .init(UIColor.systemPurple)
        }

        static var pink: Color {
            .init(UIColor.systemPink)
        }

        static var cyan: Color {
            .init(UIColor.systemCyan)
        }

        static var gray: Color {
            .init(UIColor.gray)
        }

        static var white: Color {
            .init(UIColor.white)
        }

        static var black: Color {
            .init(UIColor.black)
        }
    }

    extension UIImage: PlatformImage {}

    public extension Image {
        init(_ image: UIImage?) {
            self.image = image ?? UIImage()
        }

        init(path: String) {
            image = UIImage(contentsOfFile: path) ?? UIImage()
        }
    }

#endif
