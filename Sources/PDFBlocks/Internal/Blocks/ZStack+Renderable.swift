/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension ZStack: Renderable {
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        if keypath == \.computePageCount {
            let blocks = content.getRenderables(environment: environment)
            let result = blocks.reduce(false) { $0 || $1.computePageCount(context: context, environment: environment) }
            return Trait(computePageCount: result)[keyPath: keypath]
        } else {
            return Trait()[keyPath: keypath]
        }
    }

    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        var result: [any Renderable] = []
        for block in content.getRenderables(environment: environment) {
            if let remainder = block.remainder(context: context, environment: environment, size: size) {
                result.append(remainder)
            }
        }
        if result.isEmpty {
            return nil
        } else {
            return ZStack<ArrayBlock> {
                ArrayBlock(blocks: result)
            }
        }
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        let blocks = content.getRenderables(environment: environment)
        let sizes = blocks.map { $0.sizeFor(context: context, environment: environment, proposal: proposal) }
        let minWidthMax = sizes.map(\.min.width).reduce(0, max)
        let minHeightMax = sizes.map(\.min.height).reduce(0, max)
        let maxWidthMax = sizes.map(\.max.width).reduce(0, max)
        let maxHeightMax = sizes.map(\.max.height).reduce(0, max)
        return .init(min: .init(width: minWidthMax, height: minHeightMax),
                     max: .init(width: maxWidthMax, height: maxHeightMax))
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var result: [any Renderable] = []
        for block in content.getRenderables(environment: environment) {
            let size = block.sizeFor(context: context, environment: environment, proposal: rect.size)
            let dx: CGFloat =
                switch alignment.horizontalAlignment {
                case .leading:
                    0
                case .center:
                    (rect.width - size.max.width) / 2.0
                case .trailing:
                    rect.width - size.max.width
                }
            let dy: CGFloat =
                switch alignment.verticalAlignment {
                case .top:
                    0
                case .center:
                    (rect.height - size.max.height) / 2.0
                case .bottom:
                    rect.height - size.max.height
                }
            let renderRect = CGRect(origin: rect.origin.offset(dx: dx, dy: dy), size: size.max)
            if let remainder = block.render(context: context, environment: environment, rect: renderRect) {
                result.append(remainder)
            }
        }
        if result.isEmpty {
            return nil
        } else {
            return ZStack<ArrayBlock> {
                ArrayBlock(blocks: result)
            }
        }
    }
}
