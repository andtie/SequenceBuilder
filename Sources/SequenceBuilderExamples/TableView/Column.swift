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

    public init(header: Header, gridItem: GridItem = GridItem(), _ view: @escaping (Input, Int) -> Content) {
        self.header = header
        self.gridItem = gridItem
        self.viewBuilder = view
    }

    public func view(input: Input, row: Int) -> Content {
        viewBuilder(input, row)
    }
}

extension Column {
    public init(header: Header, alignment: Alignment, _ view: @escaping (Input, Int) -> Content) {
        self.init(header:header, gridItem: GridItem(alignment: alignment), view)
    }

    public init(gridItem: GridItem, _ view: @escaping (Input, Int) -> Content) where Header == EmptyView {
        self.init(header: EmptyView(), gridItem: gridItem, view)
    }

    public init(alignment: Alignment, _ view: @escaping (Input, Int) -> Content) where Header == EmptyView {
        self.init(header: EmptyView(), gridItem: GridItem(alignment: alignment), view)
    }

    public init(title: String, gridItem: GridItem, _ view: @escaping (Input, Int) -> Content) where Header == Text {
        self.init(header: Text(title), gridItem: gridItem, view)
    }

    public init(title: String, alignment: Alignment, _ view: @escaping (Input, Int) -> Content) where Header == Text {
        self.init(header: Text(title), gridItem: GridItem(alignment: alignment), view)
    }

    public init<Element>(header: Header, gridItem: GridItem, _ view: @escaping (Element) -> Content) where Input == [Element] {
        self.init(header:header, gridItem: gridItem, { list, row in view(list[row]) })
    }

    public init<Element>(header: Header, alignment: Alignment, _ view: @escaping (Element) -> Content) where Input == [Element] {
        self.init(header:header, gridItem: GridItem(alignment: alignment), { list, row in view(list[row]) })
    }

    public init<Element>(gridItem: GridItem = GridItem(), _ view: @escaping (Element) -> Content) where Input == [Element], Header == EmptyView {
        self.init(header: EmptyView(), gridItem: gridItem, { list, row in view(list[row]) })
    }

    public init<Element>(alignment: Alignment, _ view: @escaping (Element) -> Content) where Input == [Element], Header == EmptyView {
        self.init(header: EmptyView(), gridItem: GridItem(alignment: alignment), { list, row in view(list[row]) })
    }

    public init<Element>(title: String, gridItem: GridItem = GridItem(), _ view: @escaping (Element) -> Content) where Input == [Element], Header == Text {
        self.init(header: Text(title), gridItem: gridItem, { list, row in view(list[row]) })
    }

    public init<Element>(title: String, alignment: Alignment, _ view: @escaping (Element) -> Content) where Input == [Element], Header == Text {
        self.init(header: Text(title), gridItem: GridItem(alignment: alignment), { list, row in view(list[row]) })
    }
}
