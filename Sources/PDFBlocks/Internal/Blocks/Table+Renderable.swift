/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Table: Renderable {
    func sizeFor(context _: Context, environment: EnvironmentValues, proposal: Proposal) -> BlockSize {
        if environment.renderMode == .wrapping {
            BlockSize(width: proposal.width, height: 0)
        } else {
            BlockSize(proposal)
        }
    }

    func wrappingModeRender(context: Context, environment: EnvironmentValues, rect _: CGRect) {
        context.renderMultipageContent(block: header, environment: environment)
        if let firstGroup = groups.first {
            firstGroup.render(context: context, environment: environment, data: data) { record in
                context.renderMultipageContent(block: row(record), environment: environment)
            }
        } else {
            for record in data {
                context.renderMultipageContent(block: row(record), environment: environment)
            }
        }
        context.renderMultipageContent(block: footer, environment: environment)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) -> (any Renderable)? {
        var environment = environment

        environment.layoutAxis = .vertical
        environment.tableColumns = columns
        if environment.renderMode == .wrapping {
            // This is a secondary page wrapping block.
            // Any page header, etc will be ignored.
            wrappingModeRender(context: context, environment: environment, rect: rect)
        } else {
            // This is a primary page wrapping block.
            let frame = pageFrame(context.pageNo).getRenderable(environment: environment)
            frame.render(context: context, environment: environment, rect: rect)
            context.renderer.setLayer(2)
            guard context.multiPagePass == nil else {
                return nil
            }
            context.multiPagePass = {
                environment.renderMode = .wrapping
                wrappingModeRender(context: context, environment: environment, rect: rect)
            }
        }
        return nil
    }

    func getTrait<Value>(environment _: EnvironmentValues, keypath: KeyPath<Trait, Value>) -> Value {
        Trait(allowPageWrap: true)[keyPath: keypath]
    }
}

extension TableGroupContent {
    func render(context: Context, environment: EnvironmentValues, data: [Row], onPrintRow: (Row) -> Void) {
        let dict = [Value: [Row]].init(grouping: data, by: { $0[keyPath: value] })
        for (offset, key) in dict.keys.sorted(by: order).enumerated() {
            if let data = dict[key] {
                if offset > 0 {
                    context.advanceMultipageCursor(spacing.points)
                }
                context.renderMultipageContent(block: header(data, key), environment: environment)
                if let nextGroup {
                    nextGroup.render(context: context, environment: environment, data: data, onPrintRow: onPrintRow)
                } else {
                    for row in data {
                        onPrintRow(row)
                    }
                }
                context.renderMultipageContent(block: footer(data, key), environment: environment)
            }
        }
    }
}
