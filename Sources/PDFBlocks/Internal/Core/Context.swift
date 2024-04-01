/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

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
    var multipageRect: CGRect = .zero
    var multipageCursor: CGFloat = 0
    var onNewPage: ((Int) -> Void)?
}

extension Context {
    func render(size: PageSize, margins: EdgeInsets, content: some Block) async throws -> Data? {
        try renderer.render {
            let environment = EnvironmentValues()
            let allBlocksArePages = content.getRenderables(environment: environment)
                .reduce(true) { $0 && $1 is PageBlock }
            let blocks: [Renderable] = if allBlocksArePages {
                content.getRenderables(environment: environment)
            } else {
                [Page(size: size, margins: margins, content: { content })]
            }
            for block in blocks {
                let size = block.sizeFor(context: self, environment: environment, proposedSize: .zero)
                block.render(context: self, environment: environment, rect: CGRect(origin: .zero, size: size.max))
            }
        }
    }

    func startNewPage(newPageSize: CGSize? = nil) {
        if let newPageSize {
            pageSize = newPageSize
        }
        renderer.startNewPage(pageSize: newPageSize ?? pageSize)
        multipageCursor = 0
        pageNo += 1
        onNewPage?(pageNo)
    }

    func beginMultipageRendering(rect: CGRect, onNewPage: ((Int) -> Void)? = nil) {
        multipageRect = rect
        multipageCursor = 0
        self.onNewPage = onNewPage
    }

    private func getMultipageRenderingRect(height: CGFloat) -> CGRect {
        if (multipageRect.minY + multipageCursor + height) > multipageRect.maxY {
            startNewPage()
        }
        let result = CGRect(x: multipageRect.minX, y: multipageRect.minY + multipageCursor, width: multipageRect.width, height: height)
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

    func renderMultipageContent(block: Renderable, environment: EnvironmentValues) {
        let size = block.sizeFor(context: self, environment: environment, proposedSize: multipageRect.size)
        let renderRect = getMultipageRenderingRect(height: size.max.height)
        block.render(context: self, environment: environment, rect: renderRect)
    }

    func renderMultipageContent(height: CGFloat, callback: (CGRect) -> Void) {
        callback(getMultipageRenderingRect(height: height))
    }
}
