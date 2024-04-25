/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that can generate entire multipage data-driven
/// reports.
public struct Table<Row>: Block {
    let data: [Row]
    let columns: [any TableColumnContent<Row>]
    let groups: [any TableGroupContent<Row>]
    let header: any Block
    let footer: any Block
    let row: (Row) -> any Block
    let pageFrame: (Int) -> any Block

    public init(
        _ data: [Row],
        @TableColumnBuilder<Row> columns: @escaping () -> [any TableColumnContent<Row>],
        @TableGroupBuilder<Row> groups: @escaping () -> [any TableGroupContent<Row>] = { [] },
        @BlockBuilder header: () -> any Block = { EmptyBlock() },
        @BlockBuilder footer: () -> any Block = { EmptyBlock() },
        @BlockBuilder pageHeader: @escaping (Int) -> any Block = { _ in EmptyBlock() },
        @BlockBuilder pageFooter: @escaping (Int) -> any Block = { _ in EmptyBlock() }
    ) {
        self.data = data
        self.columns = columns()
        row = { row in
            TableRow(record: row)
        }
        self.groups = groups()
        self.header = header()
        self.footer = footer()
        pageFrame = { pageNo in
            VStack {
                AnyBlock(pageHeader(pageNo))
                TableContentSpacer()
                AnyBlock(pageFooter(pageNo))
            }
        }
    }

    public init(
        _ data: [Row],
        @TableColumnBuilder<Row> columns: @escaping () -> [any TableColumnContent<Row>],
        @BlockBuilder row: @escaping (Row) -> any Block,
        @TableGroupBuilder<Row> groups: @escaping () -> [any TableGroupContent<Row>] = { [] },
        @BlockBuilder header: () -> any Block = { EmptyBlock() },
        @BlockBuilder footer: () -> any Block = { EmptyBlock() },
        @BlockBuilder pageHeader: @escaping (Int) -> any Block = { _ in EmptyBlock() },
        @BlockBuilder pageFooter: @escaping (Int) -> any Block = { _ in EmptyBlock() }
    ) {
        self.data = data
        self.columns = columns()
        self.row = row
        self.groups = groups()
        self.header = header()
        self.footer = footer()
        pageFrame = { pageNo in
            VStack {
                AnyBlock(pageHeader(pageNo))
                TableContentSpacer()
                AnyBlock(pageFooter(pageNo))
            }
        }
    }

    public init(
        _ data: [Row],
        @TableColumnBuilder<Row> columns: @escaping () -> [any TableColumnContent<Row>],
        @TableGroupBuilder<Row> groups: @escaping () -> [any TableGroupContent<Row>] = { [] },
        @BlockBuilder header: () -> any Block = { EmptyBlock() },
        @BlockBuilder footer: () -> any Block = { EmptyBlock() },
        @BlockBuilder pageFrame: @escaping (Int) -> any Block
    ) {
        self.data = data
        self.columns = columns()
        row = { row in
            TableRow(record: row)
        }
        self.groups = groups()
        self.header = header()
        self.footer = footer()
        self.pageFrame = pageFrame
    }

    public init(
        _ data: [Row],
        @TableColumnBuilder<Row> columns: @escaping () -> [any TableColumnContent<Row>],
        @BlockBuilder row: @escaping (Row) -> any Block,
        @TableGroupBuilder<Row> groups: @escaping () -> [any TableGroupContent<Row>] = { [] },
        @BlockBuilder header: () -> any Block = { EmptyBlock() },
        @BlockBuilder footer: () -> any Block = { EmptyBlock() },
        @BlockBuilder pageFrame: @escaping (Int) -> any Block
    ) {
        self.data = data
        self.columns = columns()
        self.row = row
        self.groups = groups()
        self.header = header()
        self.footer = footer()
        self.pageFrame = pageFrame
    }
}

/// A type-erased way of referencing a TableColumn.
public protocol TableColumnContent<Row> {
    associatedtype Row

    var title: String { get }
    var width: CGFloat { get }
    var alignment: HorizontalAlignment { get }
    var visible: Bool { get }
    func cellContent(record: Row) -> any Block
}

/// A column definition for a Table.
public struct TableColumn<Row>: TableColumnContent {
    public var title: String
    public var text: (Row) -> String
    public var width: CGFloat
    public var alignment: HorizontalAlignment
    public var visible: Bool

    public init<Format>(_ title: String,
                        value: KeyPath<Row, Format.FormatInput>,
                        format: Format,
                        width: CGFloat,
                        alignment: HorizontalAlignment = .leading,
                        visible: Bool = true) where Format: FormatStyle, Format.FormatInput: Equatable, Format.FormatOutput == String
    {
        self.title = title
        text = { record in
            format.format(record[keyPath: value])
        }
        self.width = width
        self.alignment = alignment
        self.visible = visible
    }

    public init(_ title: String,
                value: KeyPath<Row, String>,
                width: CGFloat,
                alignment: HorizontalAlignment = .leading,
                visible: Bool = true)
    {
        self.title = title
        text = { record in
            record[keyPath: value]
        }
        self.width = width
        self.alignment = alignment
        self.visible = visible
    }

    public func cellContent(record: Row) -> any Block {
        Text(text(record))
    }
}

/// A custom column for a Table that does not
/// need to be mapped to a table data property.
/// It can display arbitrary content besides text.
public struct CustomTableColumn<Row>: TableColumnContent {
    public var title: String
    public var width: CGFloat
    public var alignment: HorizontalAlignment
    public var content: (Row) -> any Block
    public var visible: Bool

    public init(_ title: String,
                width: CGFloat,
                alignment: HorizontalAlignment = .leading,
                visible: Bool = true,
                @BlockBuilder content: @escaping (Row) -> any Block)
    {
        self.title = title
        self.width = width
        self.alignment = alignment
        self.visible = visible
        self.content = content
    }

    public func cellContent(record: Row) -> any Block {
        content(record)
    }
}

/// A type-erased way of referencing a TableGroup.
public protocol TableGroupContent<Row> where Value: Equatable, Value: Comparable, Value: Hashable {
    associatedtype Row
    associatedtype Value

    var order: (Value, Value) -> Bool { get }
    var value: KeyPath<Row, Value> { get }
    var header: ([Row], Value) -> any Block { get }
    var footer: ([Row], Value) -> any Block { get }
    var spacing: Dimension { get }
    var nextGroup: (any TableGroupContent<Row>)? { get set }
}

/// A group definition for a Table.
///
/// Tables
public struct TableGroup<Row, Value>: TableGroupContent where Value: Equatable, Value: Comparable, Value: Hashable {
    public let order: (Value, Value) -> Bool
    public let value: KeyPath<Row, Value>
    public let header: ([Row], Value) -> any Block
    public let footer: ([Row], Value) -> any Block
    public let spacing: Dimension
    public var nextGroup: (any TableGroupContent<Row>)?

    /// Creates a table group that will sort table data on a key path and start
    /// a new group with each change in value for that key path.
    ///
    /// - Parameters:
    ///   - on: A key path on which to sort and group table data.
    ///   - order: A sorting function
    ///   - spacing: A spacing value to apply between each group
    ///   - header: A function that receives two parameters. The first is an array
    ///     of rows within the group upon which summary values can be computed.
    ///     the second is key path value that defines the group. The function returns
    ///     a block to be rendered before the group's rows are rendered.
    ///   - footer: A function that receives two parameters. The first is an array
    ///     of rows within the group upon which summary values can be computed.
    ///     the second is key path value that defines the group. The function returns
    ///     a block to be rendered after the group's rows are rendered.
    public init(on value: KeyPath<Row, Value>,
                order: @escaping (Value, Value) -> Bool = { $0 < $1 },
                spacing: Dimension,
                @BlockBuilder header: @escaping ([Row], Value) -> any Block,
                @BlockBuilder footer: @escaping ([Row], Value) -> any Block)
    {
        self.order = order
        self.value = value
        self.header = header
        self.footer = footer
        self.spacing = spacing
        // Initialized as nil, but will be set by @TableGroupBuilder to chain groups together.
        nextGroup = nil
    }
}
