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
    //
    // A Page is rendered by renderPass1 up until it encounters a page wrap block. It defers rendering the page wrap
    // block by storing the render function in renderPass2; any overlays within pass 1 defer their rendering by
    // appending their rendering to the renderPass3 array. renderPass2 is then called to render the page wrap region.
    // When a pdf page is filled, endPage() is called and the overlay rendering functions stored in renderPass3 are
    // called. If there is more content, beginPage() is called again, calling renderPass1 again...
    var renderPass1: (() -> Void)?
    var renderPass2: (() -> Void)?
    var renderPass3: [() -> Void] = []

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
        pageWrapCursorY = 0
        renderPass1?()
    }

    func endPage() {
        // overlay blocks
        for f in renderPass3 {
            f()
        }
        renderPass3 = []
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
