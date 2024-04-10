/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Table: Renderable {
    func sizeFor(context: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        if context.multipageMode {
            BlockSize(width: proposedSize.width, height: 0)
        } else {
            BlockSize(proposedSize)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.tableColumns = columns
        context.beginMultipageRendering(environment: environment, pageFrame: pageFrame, rect: rect)
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
