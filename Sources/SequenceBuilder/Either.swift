//
// Either.swift
//
// Created by Andreas in 2020
//

import Foundation

public enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

#if canImport(SwiftUI)

import SwiftUI

extension Either: View where Left: View, Right: View {
    public var body: some View {
        switch self {
        case let .left(view):
            view
        case let .right(view):
            view
        }
    }
}

extension Either: Identifiable where Left: Identifiable, Right: Identifiable, Left.ID == Right.ID {
    public var id: Left.ID {
        switch self {
        case let .left(identifiable):
            return identifiable.id
        case let .right(identifiable):
            return identifiable.id
        }
    }
}

extension ForEach {
    /// A convenience initializer that makes it easier to use arbitrary sequences in SwiftUI
    public init<S: Sequence>(sequence: S, @ViewBuilder content: @escaping (Data.Element) -> Content)
    where Data == [(Int, S.Element)], ID == Int, Content: View
    {
        self.init(Array(sequence.enumerated()), id: \.0, content: content)
    }
}

#endif
