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
