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

protocol Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize
    func render(context: Context, environment: EnvironmentValues, rect: CGRect)
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

extension Block {
    // A Renderable will call this upon its contents to obtain it as a Renderable.
    func getRenderable(environment: EnvironmentValues) -> Renderable {
        updateEnvironmentProperties(environment: environment)
        if self is GroupBlock {
            // A group as contents of a block that is not expecting a group is treated as a VStack.
            return VStack(content: { self })
        } else if let cast = self as? any Renderable {
            // This is a Renderable.
            return cast
        } else {
            // Recursively call getRenderable upon body
            return body.getRenderable(environment: environment)
        }
    }

    // A Renderable will call this upon its contents to obtain it as an array of Renderable.
    func getRenderables(environment: EnvironmentValues) -> [Renderable] {
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
