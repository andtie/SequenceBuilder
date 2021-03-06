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

extension Either {
    public func bimap<L, R>(left: (Left) throws -> L, right: (Right) throws -> R) rethrows -> Either<L, R> {
        switch self {
        case let .left(value):
            return try .left(left(value))
        case let .right(value):
            return try .right(right(value))
        }
    }

    public func fold<T>(left: (Left) throws -> T, right: (Right) throws -> T) rethrows -> T {
        switch self {
        case let .left(value):
            return try left(value)
        case let .right(value):
            return try right(value)
        }
    }
}

extension Either: CustomStringConvertible {
    public var description: String {
        fold(left: String.init(describing:), right: String.init(describing:))
    }
}
