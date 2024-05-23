/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// Layer 1 prints everything down to the primary wrapping block.
// The primary wrapping block takes care of everything else.

// When a wrapping component begins primary rendering, it
//   1) calls context.renderer.setLayer(2)
//   2) sets context.multiPagePass block

// Context sets pageFramePass(renderLayer:)

// Context is a reference type that initiates the rendering preocess and holds rendering state.
class Context {
    init() {
        renderer = CGRenderer()
    }

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
    var pageWrapRect: CGRect = .zero
    var pageCount: Int = 0
    var layoutCache = [UUID: Any]()

    var pageNumberProxy: PageNumberProxy {
        .init(pageNo: pageNo, pageCount: pageCount)
    }

    private var pageSize: CGSize = .init(width: 8.5, height: 11).scaled(by: 72)
    private var pageWrapCursorY: CGFloat = 0

    func render(size: PageSize, margins: EdgeInsets, content: some Block) async throws -> Data? {
        let environment = EnvironmentValues()
        var blocks = content.getRenderables(environment: environment)
        let computePageCount = blocks.reduce(false) { $0 || $1.computePageCount(context: self, environment: environment) }
        
        func renderBlocks() {
            if blocks.filter({ $0.pageInfo(context: self, environment: environment) != nil }).isEmpty {
                // If Page not defined, wrap contents with a Page.
                blocks = [Page(size: size, margins: margins, content: { content })]
            }
            for block in blocks {
                guard let info = block.pageInfo(context: self, environment: environment) else {
                    // Skip stray contents that are not contained within a Page.
                    continue
                }
                let pageSize = CGSize(width: info.size.width.points, height: info.size.height.points)
                pageNo = 0
                renderer.setLayer(1)
                pageFramePass = { renderLayer in
                    self.renderer.setLayer(1)
                    self.renderer.setLayerFilter(renderLayer)
                    block.render(context: self, environment: environment, rect: CGRect(origin: .zero, size: pageSize))
                    self.renderer.setLayer(1)
                }
                beginPage(newPageSize: pageSize)
                multiPagePass?()
                endPage()
            }
        }
        
        if computePageCount {
            _ = try renderer.render {
                renderBlocks()
            }
        }
        pageCount = pageNo
        return try renderer.render {
            renderBlocks()
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

    func renderMultipageContent(block: any Block, environment: EnvironmentValues) {
        var block: (any Renderable)? = block.getRenderable(environment: environment)
        while block != nil {
            if let unwrapped = block {
                if pageWrapCursorY ~>= pageWrapRect.size.height {
                    endPage()
                    beginPage()
                    pageWrapCursorY = 0
                }
                let proposal = CGSize(width: pageWrapRect.width, height: pageWrapRect.size.height - pageWrapCursorY)
                let size = unwrapped.sizeFor(context: self, environment: environment, proposal: proposal)
                if pageWrapCursorY > 0, (pageWrapCursorY + size.max.height) ~> pageWrapRect.size.height {
                    endPage()
                    beginPage()
                    pageWrapCursorY = 0
                }
                let rect = CGRect(x: pageWrapRect.minX, y: pageWrapRect.minY + pageWrapCursorY,
                                  width: pageWrapRect.width, height: size.max.height)
                block = unwrapped.render(context: self, environment: environment, rect: rect)

                // size.max.height could be 0 because it is an EmptyBlock(); it could be 0 because
                // there is not enough room for any of it to print. If the later is the case, it
                // will return a remainder
                if let _ = block, size.max.height == 0 {
                    endPage()
                    beginPage()
                    pageWrapCursorY = 0
                }
                pageWrapCursorY += size.max.height
            }
        }
    }

    func advanceMultipageCursor(_ value: CGFloat) {
        if (pageWrapRect.minY + pageWrapCursorY + value) > pageWrapRect.maxY {
            endPage()
            beginPage()
        } else {
            pageWrapCursorY += value
        }
    }
}
