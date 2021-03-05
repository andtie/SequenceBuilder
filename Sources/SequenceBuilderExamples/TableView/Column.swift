//
// Column.swift
//
// Created by Andreas in 2021
//

import SequenceBuilder
import SwiftUI

public struct Column<Input, Header: View, Content: View>: ColumnProtocol {
    public let header: Header
    public let gridItem: GridItem
    private let viewBuilder: (Input, Int) -> Content

    public func view(input: Input, row: Int) -> Content {
        viewBuilder(input, row)
    }
}

extension Column {
    public init(_ view: @escaping (Input, Int) -> Content) where Header == EmptyView {
        self.init(header: EmptyView(), gridItem: GridItem(), viewBuilder: view)
    }

    public init<Element>(_ view: @escaping (Element) -> Content) where Input == [Element], Header == EmptyView {
        self.init(header: EmptyView(), gridItem: GridItem(), viewBuilder: { list, row in view(list[row]) })
    }
}

extension Column {
    public func header<H: View>(_ header: H) -> Column<Input, H, Content> {
        Column<Input, H, Content>(header: header, gridItem: gridItem, viewBuilder: viewBuilder)
    }

    public func title(_ title: String) -> Column<Input, Text, Content> {
        Column<Input, Text, Content>(header: Text(title), gridItem: gridItem, viewBuilder: viewBuilder)
    }

    public func gridItem(_ gridItem: GridItem) -> Self {
        Column(header: header, gridItem: gridItem, viewBuilder: viewBuilder)
    }

    public func alignment(_ alignment: Alignment) -> Self {
        let item = GridItem(gridItem.size, spacing: gridItem.spacing, alignment: alignment)
        return Column(header: header, gridItem: item, viewBuilder: viewBuilder)
    }
}
