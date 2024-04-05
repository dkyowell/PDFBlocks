/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension PageFrame: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        .init(min: proposedSize, max: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var pageNo = 1
        //  Inject functions into environment
        var layoutRect: CGRect?
        var environment = environment
        environment.sendLayoutRect = { rect in
            layoutRect = rect
        }
        environment.startNewPage = {
            pageNo += 1
            let frame = self.frame(pageNo).getRenderable(environment: environment)
            frame.render(context: context, environment: environment, rect: rect)
        }
        //  1) Render the page frame for the 1st page and capture the layout rect.
        let frame = frame(pageNo).getRenderable(environment: environment)
        frame.render(context: context, environment: environment, rect: rect)
        guard let layoutRect else {
            // LayoutReader was not used to set contentFrame
            return
        }
        //  2) Render multipage content
        content.getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: layoutRect)
    }

    func proportionalWidth(environment _: EnvironmentValues) -> Double? {
        nil
    }
}

struct SendLayoutRectKey: EnvironmentKey {
    typealias KeyType = (CGRect) -> Void
    static let defaultValue: KeyType = { _ in }
}

struct StartNewPageKey: EnvironmentKey {
    typealias KeyType = (() -> Void)?
    static let defaultValue: KeyType = nil
}

extension EnvironmentValues {
    var sendLayoutRect: SendLayoutRectKey.KeyType {
        get { self[SendLayoutRectKey.self] }
        set { self[SendLayoutRectKey.self] = newValue }
    }

    var startNewPage: StartNewPageKey.KeyType {
        get { self[StartNewPageKey.self] }
        set { self[StartNewPageKey.self] = newValue }
    }
}
