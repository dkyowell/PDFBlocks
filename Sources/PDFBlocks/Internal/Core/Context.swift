/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// Context is a reference type that holds renderer state that is shared by an entire block tree.
class Context {
    #if os(iOS) || os(macOS)
        init() {
            renderer = CGRenderer()
        }
    #endif

    init(renderer: Renderer) {
        self.renderer = renderer
    }

    let renderer: Renderer

    var pageNo = 0
    var pageSize: CGSize = .init(width: 8.5, height: 11).scaled(by: 72)
    var multipageMode = false
    var multipageFrameRect: CGRect = .zero
    var multipageRect: CGRect = .zero
    var multipageCursor: CGFloat = 0
    var pageFrame: ((Int) -> any Block)?
    var pageFrameEnvironment: EnvironmentValues = .init()
}

extension Context {
    func render(size: PageSize, margins _: EdgeInsets, content: some Block) async throws -> Data? {
        try renderer.render {
            let environment = EnvironmentValues()
            let blocks = content.getRenderables(environment: environment)
            if blocks.filter({ $0.pageInfo(context: self, environment: environment) != nil }).isEmpty {
                // no defined pages
                let page = RealPage(size: .letter, content: content.padding(.in(1)))
                let size = page.sizeFor(context: self, environment: environment, proposedSize: .zero).max
                page.render(context: self, environment: environment, rect: CGRect(origin: .zero, size: size))
            } else {
                for block in blocks {
                    if let info = block.pageInfo(context: self, environment: environment) {
                        // render defined page
                        let page = RealPage(size: info.size, content: AnyBlock(block))
                        let size = page.sizeFor(context: self, environment: environment, proposedSize: .zero).max
                        page.render(context: self, environment: environment, rect: CGRect(origin: .zero, size: size))
                    } else {
                        // render element in its own page
                        let page = RealPage(size: .letter, content: AnyBlock(block).padding(.in(1)))
                        let size = page.sizeFor(context: self, environment: environment, proposedSize: .zero).max
                        page.render(context: self, environment: environment, rect: CGRect(origin: .zero, size: size))
                    }
                }
            }
        }
    }

    func pages() {}

    func startNewPage(newPageSize: CGSize? = nil) {
        print("startNewPage")
        if let newPageSize {
            pageSize = newPageSize
        }
        renderer.startNewPage(pageSize: newPageSize ?? pageSize)
        pageNo += 1
        renderPageFrame()
    }

    func renderPageFrame() {
        if let pageFrame {
            let block = pageFrame(pageNo).getRenderable(environment: pageFrameEnvironment)
            block.render(context: self, environment: pageFrameEnvironment, rect: multipageFrameRect)
        }
        multipageCursor = 0
    }

    func beginMultipageRendering(environment: EnvironmentValues,
                                 pageFrame: ((Int) -> any Block)? = nil,
                                 rect: CGRect)
    {
        self.pageFrame = pageFrame
        pageFrameEnvironment = environment
        multipageFrameRect = rect
        multipageMode = true
        renderPageFrame()
    }

    private func getMultipageRenderingRect(height: CGFloat) -> CGRect {
        if (multipageRect.minY + multipageCursor + height) > multipageRect.maxY {
            startNewPage()
        }
        let result = CGRect(x: multipageRect.minX, y: multipageRect.minY + multipageCursor,
                            width: multipageRect.width, height: height)
        multipageCursor += height
        return result
    }

    func advanceMultipageCursor(_ value: CGFloat) {
        if (multipageRect.minY + multipageCursor + value) > multipageRect.maxY {
            startNewPage()
        } else {
            multipageCursor += value
        }
    }

    func renderMultipageContent(block: any Block, environment: EnvironmentValues) {
        renderMultipageContent(block: block.getRenderable(environment: environment), environment: environment)
    }

    func renderMultipageContent(block: any Renderable, environment: EnvironmentValues) {
        let size = block.sizeFor(context: self, environment: environment, proposedSize: multipageRect.size)
        let renderRect = getMultipageRenderingRect(height: size.max.height)
        block.render(context: self, environment: environment, rect: renderRect)
    }

    func renderMultipageContent(height: CGFloat, callback: (CGRect) -> Void) {
        callback(getMultipageRenderingRect(height: height))
    }
}
