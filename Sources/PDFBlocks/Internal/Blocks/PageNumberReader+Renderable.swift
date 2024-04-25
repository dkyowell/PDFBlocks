/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension PageNumberReader: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content(context.pageNo)
            .getRenderable(environment: environment)
            .sizeFor(context: context, environment: environment, proposal: proposal)
    }

    func contentSize(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        content(context.pageNo)
            .getRenderable(environment: environment)
            .contentSize(context: context, environment: environment, proposal: proposal)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        let remainder = content(context.pageNo)
            .getRenderable(environment: environment)
            .render(context: context, environment: environment, rect: rect)
        if let content = remainder as? Content {
            let function: (Int) -> Content = { _ in
                content
            }
            return PageNumberReader(content: function)
        } else {
            return nil
        }
    }
}
