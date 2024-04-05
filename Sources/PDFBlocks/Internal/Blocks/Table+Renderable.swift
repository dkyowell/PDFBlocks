/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// TODO: Add pageFooter functionality. It is already in the API, but does not render.
extension Table: Renderable {
    func sizeFor(context _: Context, environment _: EnvironmentValues, proposedSize: ProposedSize) -> BlockSize {
        .init(min: proposedSize, max: proposedSize)
    }

    func render(context: Context, environment: EnvironmentValues, rect: CGRect) {
        var environment = environment
        environment.isWithinMultipageContainer = true
        environment.tableColumns = columns

        context.beginMultipageRendering(rect: rect) { pageNo in
            environment.startNewPage?()
            context.renderMultipageContent(block: pageHeader(pageNo), environment: environment)
//            if printPageHeader == .always || (printPageHeader == .afterFirstPage && pageNo > 1) {
//            }
//            if printTableHeader == .always || (printTableHeader == .afterFirstPage && pageNo > 1) {
//                context.renderMultipageContent(block: TableColumnTitles(), environment: environment)
//            }
        }

        context.renderMultipageContent(block: pageHeader(1), environment: environment)

        let printRow = { (record: Row) in
            if let row {
                context.renderMultipageContent(block: row(columns, record), environment: environment)
            } else {
                context.renderMultipageContent(block: TableRow(columns: columns, record: record), environment: environment)
            }
        }

        context.renderMultipageContent(block: header, environment: environment)
//        if printTableHeader == .always {
//            context.renderMultipageContent(block: TableColumnTitles(), environment: environment)
//        }

        if let first = groups.first {
            first.render(data: data, onPrintRow: printRow, context: context, environment: environment)
        } else {
            for record in data {
                printRow(record)
            }
        }
        context.renderMultipageContent(block: footer, environment: environment)
    }

    func proportionalWidth(environment _: EnvironmentValues) -> Double? {
        nil
    }
}

extension TableGroupContent {
    func render(data: [Row], onPrintRow: (Row) -> Void, context: Context, environment: EnvironmentValues) {
        let dict = [Value: [Row]].init(grouping: data, by: { $0[keyPath: value] })
        for (offset, key) in dict.keys.sorted(by: order).enumerated() {
            if let data = dict[key], let first = data.first {
                if offset > 0 {
                    context.advanceMultipageCursor(spacing.points)
                }
                context.renderMultipageContent(block: header(data, first[keyPath: value]), environment: environment)
                if let nextGroup {
                    nextGroup.render(data: data, onPrintRow: onPrintRow, context: context, environment: environment)
                } else {
                    for row in data {
                        onPrintRow(row)
                    }
                }
                context.renderMultipageContent(block: footer(data, first[keyPath: value]), environment: environment)
            }
        }
    }
}
