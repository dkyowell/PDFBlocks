/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Text: Renderable {
    func remainder(context: Context, environment: EnvironmentValues, size: CGSize) -> (any Renderable)? {
        let remainder = context.renderer.textRemainder(value, environment: environment, rect: .init(origin: .zero, size: size))
        if remainder.length > 0, environment.truncationMode == .wrap {
            return Text(remainder)
        } else {
            return nil
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        if rect.width == 0 {
            return nil
        }
        let remainder = context.renderer.renderText(value, environment: environment, rect: rect)
        if remainder.length > 0, environment.truncationMode == .wrap {
            return Text(remainder)
        } else {
            return nil
        }
    }

    func sizeFor(context: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        if proposal.width == 0 {
            BlockSize(CGSize(width: 0, height: proposal.height))
        } else {
            BlockSize(context.renderer.sizeForText(value, environment: environment, proposal: proposal))
        }
    }
}
