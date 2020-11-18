//
// TableView.swift
//
// Created by Andreas in 2020
//

#if canImport(SwiftUI)

import SwiftUI

@available(OSX 11.0, iOS 14.0, *)
protocol TableColumn {
    associatedtype Input: Hashable
    associatedtype Content: View

    var title: String { get }
    var gridItem: GridItem { get }
    func view(input: Input) -> Content
}

@available(OSX 11.0, iOS 14.0, *)
extension Either: TableColumn where Left: TableColumn, Right: TableColumn, Left.Input == Right.Input {
    var title: String {
        switch self {
        case let .left(column):
            return column.title
        case let .right(column):
            return column.title
        }
    }

    var gridItem: GridItem {
        switch self {
        case let .left(column):
            return column.gridItem
        case let .right(column):
            return column.gridItem
        }
    }

    @ViewBuilder func view(input: Left.Input) -> some View {
        switch self {
        case let .left(column):
            column.view(input: input)
        case let .right(column):
            column.view(input: input)
        }
    }
}

@available(OSX 11.0, iOS 14.0, *)
struct TableView<Content: Sequence>: View where Content.Element: TableColumn {

    let data: [Content.Element.Input]
    let content: Content
    let titles: [String]
    let gridItems: [GridItem]

    init(data: [Content.Element.Input], @SequenceBuilder builder: () -> Content) {
        self.data = data
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

    var body: some View {
        VStack {
            header
            Color.gray.frame(height: 1)
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 8) {
                    ForEach(data, id: \.self) { row in
                        ForEach(sequence: content) { _, column in
                            column.view(input: row)
                        }
                    }
                }
            }
        }
    }
}

@available(OSX 11.0, iOS 14.0, *)
struct TableView_Previews: PreviewProvider {

    struct CodePointColumn: TableColumn {
        let title = "Codepoint"
        let gridItem = GridItem(alignment: .leading)

        func view(input: Int) -> some View {
            Text(String(format: "%02X", input))
        }
    }

    struct IntColumn: TableColumn {
        let title = "Integer"
        let gridItem = GridItem(alignment: .center)

        func view(input: Int) -> some View {
            Text(String(input))
        }
    }

    struct EmojiColumn: TableColumn {
        let title = "Emoji"
        let gridItem = GridItem(alignment: .trailing)

        func view(input: Int) -> some View {
            Text(String(Character(UnicodeScalar(input)!)))
        }
    }

    static var previews: some View {
        TableView(data: (0...79).map { $0 + 0x1f600 }) {
            CodePointColumn()
            IntColumn()
            EmojiColumn()
        }
        .padding()
    }
}

#endif
