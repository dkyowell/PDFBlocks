/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// Context is a reference type that initiates the rendering preocess and holds rendering state.
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
    // A note on render passes:
    // Because new page commands can be issued, rendering cannot simply walk down the block tree and back up again,
    // rendering as it goes along. On the way back up the tree, blocks might draw themselves on an entirely different
    // page than they expect.
    var pageFramePass: ((Int) -> Void)?
    var multiPagePass: (() -> Void)?

    private var pageSize: CGSize = .init(width: 8.5, height: 11).scaled(by: 72)
    private var pageWrapRect: CGRect = .zero
    private var pageWrapCursorY: CGFloat = 0

    func render(size: PageSize, margins: EdgeInsets, content: some Block) async throws -> Data? {
        try renderer.render {
            let environment = EnvironmentValues()
            let blocks = content.getRenderables(environment: environment)
            if blocks.filter({ $0.pageInfo(context: self, environment: environment) != nil }).isEmpty {
                // no defined pages. collect all into a VStack
                let pageSize = CGSize(width: size.width.points, height: size.height.points)
                let page = Page(size: size, margins: margins, content: { content })
                pageFramePass = { renderLayer in
                    self.renderer.setLayer(1)
                    self.renderer.setRenderLayer(renderLayer)
                    page.render(context: self, environment: environment, rect: CGRect(origin: .zero, size: pageSize))
                    self.renderer.setLayer(1)
                }
                beginPage(newPageSize: pageSize)
                multiPagePass?()
                endPage()
            } else {
                for block in blocks {
                    guard let info = block.pageInfo(context: self, environment: environment) else {
                        // drop stray blocks
                        continue
                    }
                    let pageSize = CGSize(width: info.size.width.points, height: info.size.height.points)
                    pageFramePass = { renderLayer in
                        self.renderer.setLayer(1)
                        self.renderer.setRenderLayer(renderLayer)
                        block.render(context: self, environment: environment, rect: CGRect(origin: .zero, size: pageSize))
                        self.renderer.setLayer(1)
                    }
                    beginPage(newPageSize: pageSize)
                    multiPagePass?()
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
        pageWrapCursorY = 0
        pageFramePass?(1)
    }

    func endPage() {
        pageFramePass?(2)
        renderer.endPage()
    }

    func setPageWrapRect(_ rect: CGRect) {
        pageWrapRect = rect
        pageWrapCursorY = 0
    }

    private func getMultipageRenderingRect(height: CGFloat) -> CGRect {
        if (pageWrapRect.minY + pageWrapCursorY + height) > pageWrapRect.maxY {
            endPage()
            beginPage()
        }
        let result = CGRect(x: pageWrapRect.minX, y: pageWrapRect.minY + pageWrapCursorY,
                            width: pageWrapRect.width, height: height)
        pageWrapCursorY += height
        return result
    }

    private func getMultipageRenderingRect(rect: CGRect, height: CGFloat) -> CGRect {
        if (pageWrapRect.minY + pageWrapCursorY + height) > pageWrapRect.maxY {
            endPage()
            beginPage()
        }
        let result = CGRect(x: rect.minX, y: pageWrapRect.minY + pageWrapCursorY,
                            width: rect.width, height: height)
        pageWrapCursorY += height
        return result
    }

    func advanceMultipageCursor(_ value: CGFloat) {
        if (pageWrapRect.minY + pageWrapCursorY + value) > pageWrapRect.maxY {
            endPage()
            beginPage()
        } else {
            pageWrapCursorY += value
        }
    }

    func renderMultipageContent(block: any Block, environment: EnvironmentValues) {
        renderMultipageContent(block: block.getRenderable(environment: environment), environment: environment)
    }

    func renderMultipageContent(block: any Renderable, environment: EnvironmentValues) {
        let size = block.sizeFor(context: self, environment: environment, proposedSize: pageWrapRect.size)
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
