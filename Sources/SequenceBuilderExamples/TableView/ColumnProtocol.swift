//
// ColumnProtocol.swift
//
// Created by Andreas in 2021
//

import SequenceBuilder
import SwiftUI

public protocol ColumnProtocol {
    associatedtype Input
    associatedtype Header: View
    associatedtype Content: View

    var header: Header { get }
    var gridItem: GridItem { get }
    func view(input: Input, row: Int) -> Content
}

extension Either: ColumnProtocol where Left: ColumnProtocol, Right: ColumnProtocol, Left.Input == Right.Input {
    public var header: Either<Left.Header, Right.Header> {
        switch self {
        case let .left(column):
            return .left(column.header)
        case let .right(column):
            return .right(column.header)
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
