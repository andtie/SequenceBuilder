//
// TableView.swift
//
// Created by Andreas in 2020
//

import SequenceBuilder
import SwiftUI

public struct TableView<Column: ColumnProtocol, Style: TableStyle>: View where Style.Cell == Column.Content, Style.Header == Column.Header {

    let style: Style
    let configuration: TableStyleConfiguration<Style.Header, Style.Cell>

    public init(style: Style, input: Column.Input, rowCount: Int, @SequenceBuilder builder: () -> [Column]) {
        let columns = Array(builder())
        let gridItems = columns.map(\.gridItem)
        self.style = style
        self.configuration = TableStyleConfiguration(
            gridItems: gridItems,
            columns: columns.count,
            rows: rowCount,
            header: { column in columns[column].header },
            cell: { row, column in columns[column].view(input: input, row: row) }
        )
    }

    public var body: some View {
        style.makeBody(configuration: configuration)
    }
}

extension TableView {
    public init(input: Column.Input, rowCount: Int, @SequenceBuilder builder: () -> [Column]) where Style == DefaultTableStyle<Column.Header, Column.Content> {
        self.init(style: DefaultTableStyle(), input: input, rowCount: rowCount, builder: builder)
    }

    public init<C: Collection>(style: Style, collection: C, @SequenceBuilder builder: () -> [Column]) where C == Column.Input {
        self.init(style: style, input: collection, rowCount: collection.count, builder: builder)
    }

    public init<C: Collection>(collection: C, @SequenceBuilder builder: () -> [Column]) where C == Column.Input, Style == DefaultTableStyle<Column.Header, Column.Content> {
        self.init(style: DefaultTableStyle(), input: collection, rowCount: collection.count, builder: builder)
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(collection: (0...79).map { $0 + 0x1f600 }) {
            Column(title: "Codepoint", alignment: .leading) { (input: Int) in
                Text(String(format: "%02X", input))
            }
            Column(title: "Integer", alignment: .center) { (input: Int) in
                Text(String(input))
            }
            Column(alignment: .trailing) { (input: Int) in
                Text(String(Character(UnicodeScalar(input)!)))
            }
        }
        .padding()
    }
}
