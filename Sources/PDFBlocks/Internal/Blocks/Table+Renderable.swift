/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

extension Table: Renderable {
    func sizeFor(context: Context, environment: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        if context.multipageMode {
            BlockSize(width: proposedSize.width, height: 0)
        } else {
            BlockSize(proposedSize)
        }
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.tableColumns = columns
        func printRow(_ record: Row) {
            if let row {
                context.renderMultipageContent(block: row(columns, record), environment: environment)
            } else {
                context.renderMultipageContent(block: TableRow(record: record), environment: environment)
            }
        }
        context.beginMultipageRendering(environment: environment, rect: rect, footer: pageFooter) { pageNo in
            // This is the new page function called on the start of subsequant pages.
            environment.startNewPage?()
            context.renderMultipageContent(block: pageHeader(pageNo), environment: environment)
            if printColumnTitles {
                context.renderMultipageContent(block: TableColumnTitles(), environment: environment)
            }
        }
        if printColumnTitles {
            context.renderMultipageContent(block: TableColumnTitles(), environment: environment)
        }
        // If embedded...this should not be page 1
        context.renderMultipageContent(block: pageHeader(1), environment: environment)
        context.renderMultipageContent(block: header, environment: environment)
        if let firstGroup = groups.first {
            firstGroup.render(data: data, onPrintRow: printRow, context: context, environment: environment)
        } else {
            for record in data {
                printRow(record)
            }
        }
        context.renderMultipageContent(block: footer, environment: environment)
        context.renderPageFooter()
    }
}

extension TableGroupContent {
    func render(data: [Row], onPrintRow: (Row) -> Void, context: Context, environment: EnvironmentValues) {
        let dict = [Value: [Row]].init(grouping: data, by: { $0[keyPath: value] })
        for (offset, key) in dict.keys.sorted(by: order).enumerated() {
            if let data = dict[key] {
                if offset > 0 {
                    context.advanceMultipageCursor(spacing.points)
                }
                context.renderMultipageContent(block: header(data, key), environment: environment)
                if let nextGroup {
                    nextGroup.render(data: data, onPrintRow: onPrintRow, context: context, environment: environment)
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
