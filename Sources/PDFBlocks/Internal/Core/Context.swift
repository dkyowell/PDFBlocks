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

    var renderPass1: (() -> Void)?
    var renderPass2: (() -> Void)?
    var renderPass3: [() -> Void] = []
}

extension Context {
    func render(size: PageSize, margins: EdgeInsets, content: some Block) async throws -> Data? {
        try renderer.render {
            var environment = EnvironmentValues()
            environment.pageNo = {
                self.pageNo
            }
            let blocks = content.getRenderables(environment: environment)
            if blocks.filter({ $0.pageInfo(context: self, environment: environment) != nil }).isEmpty {
                // no defined pages. collect all into a VStack
                let pageSize = CGSize(width: size.width.points, height: size.height.points)
                let page = Page(size: size, margins: margins, content: {content})
                renderPass1 = {
                    page.render(context: self, environment: environment, rect: CGRect(origin: .zero, size: pageSize))
                }
                beginPage(newPageSize: pageSize)
                renderPass2?()
                endPage()
            } else {
                for block in blocks {
                    guard let info = block.pageInfo(context: self, environment: environment) else {
                        // drop stray blocks
                        continue
                    }
                    let pageSize = CGSize(width: info.size.width.points, height: info.size.height.points)
                    renderPass1 = {
                        block.render(context: self, environment: environment, rect: CGRect(origin: .zero, size: pageSize))
                    }
                    beginPage(newPageSize: pageSize)
                    renderPass2?()
                    endPage()
                }
            }
        }
    }

    func beginPage(newPageSize: CGSize? = nil) {
        if let newPageSize {
            pageSize = newPageSize
        }
        renderer.startNewPage(pageSize: newPageSize ?? pageSize)
        pageNo += 1
        multipageCursor = 0
        //renderPass1Block?.render(context: self, environment: environment, rect: .init(origin: .zero, size: pageSize))
        renderPass1?()
        renderPageFrame()
    }

    func endPage() {
        for f in renderPass3 {
            f()
        }
        renderPass3 = []
        renderer.endPage()
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
        guard multipageMode == false else {
            return
        }
        self.pageFrame = pageFrame
        pageFrameEnvironment = environment
        multipageFrameRect = rect
        multipageRect = rect
        multipageMode = true
        renderPageFrame()
    }

    private func getMultipageRenderingRect(height: CGFloat) -> CGRect {
        if (multipageRect.minY + multipageCursor + height) > multipageRect.maxY {
            endPage()
            beginPage()
        }
        let result = CGRect(x: multipageRect.minX, y: multipageRect.minY + multipageCursor,
                            width: multipageRect.width, height: height)
        multipageCursor += height
        return result
    }

    private func getMultipageRenderingRect(rect: CGRect, height: CGFloat) -> CGRect {
        if (multipageRect.minY + multipageCursor + height) > multipageRect.maxY {
            endPage()
            beginPage()
        }
        let result = CGRect(x: rect.minX, y: multipageRect.minY + multipageCursor,
                            width: rect.width, height: height)
        multipageCursor += height
        return result
    }

    func advanceMultipageCursor(_ value: CGFloat) {
        if (multipageRect.minY + multipageCursor + value) > multipageRect.maxY {
            endPage()
            beginPage()
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

    func renderMultipageContent(rect: CGRect, height: CGFloat, callback: (CGRect) -> Void) {
        callback(getMultipageRenderingRect(rect: rect, height: height))
    }
}
