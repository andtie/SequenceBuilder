//
// TableStyle.swift
//
// Created by Andreas in 2021
//

import SwiftUI

public protocol TableStyle {
    /// A view that represents the body of a table.
    associatedtype Body: View

    /// A view that represents the header of a table column.
    associatedtype Header: View

    /// A view that represents the cell of a table.
    associatedtype Cell: View

    /// The properties of a table.
    typealias Configuration = TableStyleConfiguration<Header, Cell>

    /// Creates a view that represents the body of a table.
    func makeBody(configuration: Configuration) -> Body
}

public struct TableStyleConfiguration<Header: View, Cell: View> {
    public let gridItems: [GridItem]
    public let columns: Int
    public let rows: Int
    public let header: (Int) -> Header
    public let cell: (Int, Int) -> Cell
}

public struct DefaultTableStyle<Header: View, Cell: View>: TableStyle {
    public init() {}

    public func makeBody(configuration: TableStyleConfiguration<Header, Cell>) -> some View {
        VStack {
            LazyVGrid(columns: configuration.gridItems) {
                ForEach(0..<configuration.columns, id: \.self) { column in
                    configuration.header(column)
                }
            }
            .font(.headline)
            Color(UIColor.label).frame(height: 1)
            ScrollView {
                LazyVGrid(columns: configuration.gridItems, spacing: 8) {
                    ForEach(0..<configuration.rows, id: \.self) { row in
                        ForEach(0..<configuration.columns, id: \.self) { column in
                            configuration.cell(row, column)
                        }
                    }
                }
            }
        }
    }
}
