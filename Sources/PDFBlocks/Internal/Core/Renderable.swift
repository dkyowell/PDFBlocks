/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

//

//  Every Block will either be a composite block that implements a body composed of other
//  Blocks or a PrimitiveBlock that implements

//  The layout system is much simpler than SwiftUI which involves a more prolonged negotiaion
//  between view and subview.
//
//  A block tells a subblock how large it can ben and the subblock returns the maximum size it
//  wants to be. The block will then render the subblock at that size, or will shrink the size
//  if necessary.

protocol Renderable: Block {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize
    @discardableResult func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)?
    func getTrait<Value>(context: Context, environment: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value
    /// Used only by Columns. Used in measuring content height for balancing column length.
    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)?
}

extension Renderable {
    // This extension provideds a Block body conformance for all Renderable blocks.
    // A renderable block should never have its body evaluated. If it is evaluated, an error has
    // occoured, so behavior is undefined and it would be best to throw a fatalError. This can be
    // accomplished by extending Never to conform to Block. Since fatalError() returns Never,
    // fatalError() can be used as a Block.
    public var body: Never {
        fatalError()
    }
}

// Default getTrait implementation
extension Renderable {
    func getTrait<Value>(context _: Context, environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait()[keyPath: keypath]
    }
}

extension Renderable {
    func remainder(context _: Context, environment _: EnvironmentValues, size _: CGSize) -> (any Renderable)? {
        nil
    }
}

extension Block {
    // A Renderable will call this upon its contents to obtain it as a Renderable.
    func getRenderable(environment: EnvironmentValues) -> any Renderable {
        updateEnvironmentProperties(environment: environment)
        if self is GroupBlock {
            // A group as contents of a block that is not expecting a group is treated as a VStack.
            return VStack(content: { self })
        } else if let cast = self as? any Renderable {
            return cast
        } else {
            // Recursively call getRenderable upon body
            return body.getRenderable(environment: environment)
        }
    }

    // A Renderable will call this upon its contents to obtain it as an array of Renderable.
    func getRenderables(environment: EnvironmentValues) -> [any Renderable] {
        updateEnvironmentProperties(environment: environment)
        if let cast = self as? any GroupBlock {
            return cast.flattenedBlocks().map { $0.getRenderable(environment: environment) }
        } else if let cast = self as? any Renderable {
            return [cast]
        } else {
            return body.getRenderables(environment: environment)
        }
    }

    func updateEnvironmentProperties(environment: EnvironmentValues) {
        for property in Mirror(reflecting: self).children.compactMap({ $0.value as? EnvironmentProperty }) {
            property.update(environment)
        }
    }
}

// These "shortcut" functions are for more ergonomic expression from calling site.
extension Renderable {
    func proportionalWidth(context: Context, environment: EnvironmentValues) -> Double? {
        getTrait(context: context, environment: environment, keypath: \.proprtionalWidth)
    }

    // Only used in isSecondaryPageWrapBlock
    func allowWrap(context: Context, environment: EnvironmentValues) -> Bool {
        getTrait(context: context, environment: environment, keypath: \.wrapContents)
    }

    func layoutPriority(context: Context, environment: EnvironmentValues) -> Int {
        getTrait(context: context, environment: environment, keypath: \.layoutPriority)
    }

    func pageInfo(context: Context, environment: EnvironmentValues) -> PageInfo? {
        getTrait(context: context, environment: environment, keypath: \.pageInfo)
    }

    func computePageCount(context: Context, environment: EnvironmentValues) -> Bool {
        getTrait(context: context, environment: environment, keypath: \.computePageCount)
    }

    func isSpacer(context: Context, environment: EnvironmentValues) -> Bool {
        getTrait(context: context, environment: environment, keypath: \.isSpacer)
    }
}

extension Renderable {
    // Only used in one place: ProportionalFrame
    func isSecondaryPageWrapBlock(context: Context, environment: EnvironmentValues) -> Bool {
        (environment.renderMode == .wrapping) && allowWrap(context: context, environment: environment)
    }
}
