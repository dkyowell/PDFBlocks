/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

/// A block that can generate entire multipage data-driven
/// reports.
public struct Table<Row>: MultipageBlock {
    let data: [Row]
    let printTableHeader: PrintWhen
    let printPageHeader: PrintWhen
    let columns: [any TableColumnContent<Row>]
    let groups: [any TableGroupContent<Row>]
    let header: any Block
    let footer: any Block
    let row: (([any TableColumnContent<Row>], Row) -> (any Block))?
    let pageHeader: (Int) -> (any Block)

    public init(
        data: [Row],
        printTableHeader: PrintWhen = .always,
        printPageHeader: PrintWhen = .never,
        @TableColumnBuilder<Row> columns: @escaping () -> [any TableColumnContent<Row>],
        @BlockBuilder header: () -> any Block = { EmptyBlock() },
        @TableGroupBuilder<Row> groups: @escaping () -> [any TableGroupContent<Row>] = { [] },
        @BlockBuilder footer: () -> any Block = { EmptyBlock() },
        pageHeader: @escaping (Int) -> any Block = { _ in EmptyBlock() }
    ) {
        self.data = data
        self.printTableHeader = printTableHeader
        self.printPageHeader = printPageHeader
        self.columns = columns()
        self.groups = groups()
        self.header = header()
        row = nil
        self.footer = footer()
        self.pageHeader = pageHeader
    }

    public init(
        data: [Row],
        printTableHeader: PrintWhen = .always,
        printPageHeader: PrintWhen = .never,
        @TableColumnBuilder<Row> columns: @escaping () -> [any TableColumnContent<Row>],
        @BlockBuilder header: () -> any Block = { EmptyBlock() },
        @TableGroupBuilder<Row> groups: @escaping () -> [any TableGroupContent<Row>] = { [] },
        @BlockBuilder row: @escaping ([any TableColumnContent<Row>], Row) -> any Block,
        @BlockBuilder footer: () -> any Block = { EmptyBlock() },
        pageHeader: @escaping (Int) -> any Block = { _ in EmptyBlock() }
    ) {
        self.data = data
        self.printTableHeader = printTableHeader
        self.printPageHeader = printPageHeader
        self.columns = columns()
        self.groups = groups()
        self.header = header()
        self.row = row
        self.footer = footer()
        self.pageHeader = pageHeader
    }

    public enum PrintWhen {
        case always
        case afterFirstPage
        case never
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
public struct TableColumn<Row, Format>: TableColumnContent where Format: FormatStyle, Format.FormatInput: Equatable, Format.FormatOutput == String {
    public typealias TableRowValue = Row

    public var title: String
    public var value: KeyPath<TableRowValue, Format.FormatInput>
    public var format: Format
    public var width: CGFloat
    public var alignment: HorizontalAlignment
    public var visible: Bool

    public init(_ title: String,
                value: KeyPath<Row, Format.FormatInput>,
                format: Format,
                width: CGFloat,
                alignment: HorizontalAlignment,
                visible: Bool = true)
    {
        self.title = title
        self.value = value
        self.format = format
        self.width = width
        self.alignment = alignment
        self.visible = visible
    }

    public init(_ title: String,
                value: KeyPath<Row, Format.FormatInput>,
                width: CGFloat,
                alignment: HorizontalAlignment,
                visible: Bool = true) where Format == StringFormatStyle
    {
        self.title = title
        self.value = value
        format = StringFormatStyle()
        self.width = width
        self.alignment = alignment
        self.visible = visible
    }

    public func cellContent(record: Row) -> any Block {
        Text(record[keyPath: value], format: format)
    }
}

/// A custom column for a Table that does not
/// need to be mapped to a table data property.
/// It can display arbitrary content besides text.
public struct CustomTableColumn<Row>: TableColumnContent {
    public typealias TableRowValue = Row

    public var title: String
    public var width: CGFloat
    public var alignment: HorizontalAlignment
    public var content: (Row) -> any Block
    public var visible: Bool

    public init(_ title: String,
                width: CGFloat,
                alignment: HorizontalAlignment,
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
    var spacing: Size { get }
    var nextGroup: (any TableGroupContent<Row>)? { get set }
}

/// A group definition for a Table.
public struct TableGroup<Row, Value>: TableGroupContent where Value: Equatable, Value: Comparable, Value: Hashable {
    public let order: (Value, Value) -> Bool
    public let value: KeyPath<Row, Value>
    public let header: ([Row], Value) -> any Block
    public let footer: ([Row], Value) -> any Block
    public let spacing: Size
    public var nextGroup: (any TableGroupContent<Row>)?

    public init(on value: KeyPath<Row, Value>,
                order: @escaping (Value, Value) -> Bool = { $0 < $1 },
                spacing: Size,
                @BlockBuilder header: @escaping ([Row], Value) -> any Block,
                @BlockBuilder footer: @escaping ([Row], Value) -> any Block)
    {
        self.order = order
        self.value = value
        self.header = header
        self.footer = footer
        self.spacing = spacing
        nextGroup = nil
    }
}
