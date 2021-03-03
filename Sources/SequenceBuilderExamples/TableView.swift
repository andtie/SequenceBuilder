//
// TableView.swift
//
// Created by Andreas in 2020
//

#if canImport(SwiftUI)

import SequenceBuilder
import SwiftUI

public protocol TableColumn {
    associatedtype Input: Hashable
    associatedtype Content: View

    var title: String { get }
    var gridItem: GridItem { get }
    func view(input: Input, row: Int) -> Content
}

extension Either: TableColumn where Left: TableColumn, Right: TableColumn, Left.Input == Right.Input {
    public var title: String {
        switch self {
        case let .left(column):
            return column.title
        case let .right(column):
            return column.title
        }
    }

    public var gridItem: GridItem {
        switch self {
        case let .left(column):
            return column.gridItem
        case let .right(column):
            return column.gridItem
        }
    }

    @ViewBuilder public func view(input: Left.Input, row: Int) -> some View {
        switch self {
        case let .left(column):
            column.view(input: input, row: row)
        case let .right(column):
            column.view(input: input, row: row)
        }
    }
}

public struct TableView<Content: Sequence>: View where Content.Element: TableColumn {

    let input: Content.Element.Input
    let rowCount: Int
    let content: Content
    let titles: [String]
    let gridItems: [GridItem]

    public init(input: Content.Element.Input, rowCount: Int, @SequenceBuilder builder: () -> Content) {
        self.input = input
        self.rowCount = rowCount
        self.content = builder()
        self.titles = content.map(\.title)
        self.gridItems = content.map(\.gridItem)
    }

    public init<C: Collection>(collection: C, @SequenceBuilder builder: () -> Content) where C == Content.Element.Input {
        self.input = collection
        self.rowCount = collection.count
        self.content = builder()
        self.titles = content.map(\.title)
        self.gridItems = content.map(\.gridItem)
    }

    var header: some View {
        LazyVGrid(columns: gridItems) {
            ForEach(sequence: titles) { _, title in
                Text(title)
            }
        }
        .font(.headline)
    }

    public var body: some View {
        VStack {
            header
            Color.gray.frame(height: 1)
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 8) {
                    ForEach(0..<rowCount, id: \.self) { row in
                        ForEach(sequence: content) { _, column in
                            column.view(input: input, row: row)
                        }
                    }
                }
            }
        }
    }
}

struct TableView_Previews: PreviewProvider {

    struct CodePointColumn: TableColumn {
        let title = "Codepoint"
        let gridItem = GridItem(alignment: .leading)

        func view(input: [Int], row: Int) -> some View {
            Text(String(format: "%02X", input[row]))
        }
    }

    struct IntColumn: TableColumn {
        let title = "Integer"
        let gridItem = GridItem(alignment: .center)

        func view(input: [Int], row: Int) -> some View {
            Text(String(input[row]))
        }
    }

    struct EmojiColumn: TableColumn {
        let title = "Emoji"
        let gridItem = GridItem(alignment: .trailing)

        func view(input: [Int], row: Int) -> some View {
            Text(String(Character(UnicodeScalar(input[row])!)))
        }
    }

    static var previews: some View {
        TableView(collection: (0...79).map { $0 + 0x1f600 }) {
            CodePointColumn()
            IntColumn()
            EmojiColumn()
        }
        .padding()
    }
}

#endif
