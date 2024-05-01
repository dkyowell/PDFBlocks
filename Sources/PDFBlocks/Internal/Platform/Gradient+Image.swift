/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

#if os(iOS)
    import UIKit

    extension LinearGradient {
        func image(rect: CGRect) -> UIImage {
            print(rect)
            return UIGraphicsImageRenderer(size: CGSize(width: rect.width, height: 72 * 11)).image { context in
                guard let cgGradient = CGGradient(colorsSpace: nil,
                                                  colors: gradient.stops.map(\.color.cgColor) as CFArray,
                                                  locations: gradient.stops.map(\.location))
                else {
                    return
                }
                let startX = rect.minX + startPoint.x * rect.size.width
                let startY = rect.minY + startPoint.y * rect.size.height
                let endX = rect.minX + endPoint.x * rect.size.width
                let endY = rect.minY + endPoint.y * rect.size.height
                print(72 * 11, startY, endY)
                // Reverse start and end for CoreText rendering
                context.cgContext.drawLinearGradient(cgGradient,
                                                     start: .init(x: startX, y: startY),
                                                     end: .init(x: endX, y: endY),
                                                     options: [.drawsAfterEndLocation])
            }
        }
    }

    extension RadialGradient {
        func image(size: CGSize) -> UIImage {
            UIGraphicsImageRenderer(size: size).image { context in
                guard let cgGradient = CGGradient(colorsSpace: nil,
                                                  colors: gradient.stops.map(\.color.cgColor) as CFArray,
                                                  locations: gradient.stops.map(\.location))
                else {
                    return
                }
                let startX = center.x * size.width
                let startY = center.y * size.height
                context.cgContext.drawRadialGradient(cgGradient,
                                                     startCenter: .init(x: startX, y: startY),
                                                     startRadius: startRadius.points,
                                                     endCenter: .init(x: startX, y: startY),
                                                     endRadius: endRadius.points,
                                                     options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
            }
        }
    }

#endif
