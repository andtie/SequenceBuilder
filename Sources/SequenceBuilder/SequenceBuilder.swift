//
// SequenceBuilder.swift
//
// Created by Andreas in 2020
//

@resultBuilder
public enum SequenceBuilder {

    public typealias S1<C0, C1> = Either<C0, C1>
    public typealias S2<C0, C1, C2> = Either<C0, S1<C1, C2>>
    public typealias S3<C0, C1, C2, C3> = Either<C0, S2<C1, C2, C3>>
    public typealias S4<C0, C1, C2, C3, C4> = Either<C0, S3<C1, C2, C3, C4>>
    public typealias S5<C0, C1, C2, C3, C4, C5> = Either<C0, S4<C1, C2, C3, C4, C5>>
    public typealias S6<C0, C1, C2, C3, C4, C5, C6> = Either<C0, S5<C1, C2, C3, C4, C5, C6>>
    public typealias S7<C0, C1, C2, C3, C4, C5, C6, C7> = Either<C0, S6<C1, C2, C3, C4, C5, C6, C7>>
    public typealias S8<C0, C1, C2, C3, C4, C5, C6, C7, C8> = Either<C0, S7<C1, C2, C3, C4, C5, C6, C7, C8>>
    public typealias S9<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9> = Either<C0, S8<C1, C2, C3, C4, C5, C6, C7, C8, C9>>

    // MARK: - Conditionals

    /// Provides support for “if” statements in multi-statement closures,
    /// producing optional content that is visible only when the condition
    /// evaluates to `true`.
    public static func buildIf<Content>(_ content: Content?) -> [Content] {
        content.map { [$0] } ?? []
    }

    /// Provides support for “if” statements in multi-statement closures,
    /// producing optional content that is visible only when the condition
    /// evaluates to `true`.
    public static func buildIf<Content>(_ content: Content?) -> [Content.Element] where Content: Sequence {
        content.map { Array($0) } ?? []
    }

    /// Just a workaround to satisfy the compiler.
    /// If we would directly specify `Either<TrueContent.Element, FalseContent.Element>` as a result of `buildEither`,
    /// then it would complain that it cannot infer `FalseContent` / `TrueContent` since it is not passed as a parameter
    public struct EitherSequence<L: Sequence, R: Sequence>: Sequence {
        public typealias S = [Either<L.Element, R.Element>]

        let array: S

        init(_ array: S) {
            self.array = array
        }

        public func makeIterator() -> S.Iterator {
            array.makeIterator()
        }
    }

    /// Provides support for "if" statements in multi-statement closures,
    /// producing conditional content for the "then" branch.
    public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> EitherSequence<TrueContent, FalseContent> where TrueContent: Sequence, FalseContent: Sequence {
        EitherSequence(first.map(Either.left))
    }

    /// Provides support for "if-else" statements in multi-statement closures,
    /// producing conditional content for the "else" branch.
    public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> EitherSequence<TrueContent, FalseContent> where TrueContent: Sequence, FalseContent: Sequence  {
        EitherSequence(second.map(Either.right))
    }

    // MARK: - Expressions

    public static func buildExpression<C0>() -> [C0] {
        []
    }

    public static func buildExpression<C0>(_ c0: C0) -> [C0] {
        [c0]
    }

    public static func buildExpression<C0, C1>(_ c0: C0, _ c1: C1)
    -> [S1<C0, C1>]
    {
        [Either.left(c0), Either.right(c1)]
    }

    public static func buildExpression<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2)
    -> [S2<C0, C1, C2>]
    {
        [Either.left(c0)] + buildExpression(c1, c2).map(Either.right)
    }

    public static func buildExpression<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3)
    -> [S3<C0, C1, C2, C3>]
    {
        [Either.left(c0)] + buildExpression(c1, c2, c3).map(Either.right)
    }

    public static func buildExpression<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4)
    -> [S4<C0, C1, C2, C3, C4>]
    {
        [Either.left(c0)] + buildExpression(c1, c2, c3, c4).map(Either.right)
    }

    public static func buildExpression<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5)
    -> [S5<C0, C1, C2, C3, C4, C5>]
    {
        [Either.left(c0)] + buildExpression(c1, c2, c3, c4, c5).map(Either.right)
    }

    public static func buildExpression<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6)
    -> [S6<C0, C1, C2, C3, C4, C5, C6>]
    {
        [Either.left(c0)] + buildExpression(c1, c2, c3, c4, c5, c6).map(Either.right)
    }

    public static func buildExpression<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7)
    -> [S7<C0, C1, C2, C3, C4, C5, C6, C7>]
    {
        [Either.left(c0)] + buildExpression(c1, c2, c3, c4, c5, c6, c7).map(Either.right)
    }

    public static func buildExpression<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8)
    -> [S8<C0, C1, C2, C3, C4, C5, C6, C7, C8>]
    {
        [Either.left(c0)] + buildExpression(c1, c2, c3, c4, c5, c6, c7, c8).map(Either.right)
    }

    public static func buildExpression<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9)
    -> [S9<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>]
    {
        [Either.left(c0)] + buildExpression(c1, c2, c3, c4, c5, c6, c7, c8, c9).map(Either.right)
    }

    // MARK: - Blocks

    public static func buildBlock<C0>() -> [C0] {
        []
    }

    public static func buildBlock<C0>(_ c0: C0)
    -> C0
    where C0: Sequence
    {
        c0
    }

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1)
    -> [S1<C0.Element, C1.Element>]
    where C0: Sequence, C1: Sequence
    {
        c0.map(Either.left) + c1.map(Either.right)
    }

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2)
    -> [S2<C0.Element, C1.Element, C2.Element>]
    where C0: Sequence, C1: Sequence, C2: Sequence
    {
        c0.map(Either.left) + buildBlock(c1, c2).map(Either.right)
    }

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3)
    -> [S3<C0.Element, C1.Element, C2.Element, C3.Element>]
    where C0: Sequence, C1: Sequence, C2: Sequence, C3: Sequence
    {
        c0.map(Either.left) + buildBlock(c1, c2, c3).map(Either.right)
    }

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4)
    -> [S4<C0.Element, C1.Element, C2.Element, C3.Element, C4.Element>]
    where C0: Sequence, C1: Sequence, C2: Sequence, C3: Sequence, C4: Sequence
    {
        c0.map(Either.left) + buildBlock(c1, c2, c3, c4).map(Either.right)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5)
    -> [S5<C0.Element, C1.Element, C2.Element, C3.Element, C4.Element, C5.Element>]
    where C0: Sequence, C1: Sequence, C2: Sequence, C3: Sequence, C4: Sequence, C5: Sequence
    {
        c0.map(Either.left) + buildBlock(c1, c2, c3, c4, c5).map(Either.right)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6)
    -> [S6<C0.Element, C1.Element, C2.Element, C3.Element, C4.Element, C5.Element, C6.Element>]
    where C0: Sequence, C1: Sequence, C2: Sequence, C3: Sequence, C4: Sequence, C5: Sequence, C6: Sequence
    {
        c0.map(Either.left) + buildBlock(c1, c2, c3, c4, c5, c6).map(Either.right)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7)
    -> [S7<C0.Element, C1.Element, C2.Element, C3.Element, C4.Element, C5.Element, C6.Element, C7.Element>]
    where C0: Sequence, C1: Sequence, C2: Sequence, C3: Sequence, C4: Sequence, C5: Sequence, C6: Sequence, C7: Sequence
    {
        c0.map(Either.left) + buildBlock(c1, c2, c3, c4, c5, c6, c7).map(Either.right)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8)
    -> [S8<C0.Element, C1.Element, C2.Element, C3.Element, C4.Element, C5.Element, C6.Element, C7.Element, C8.Element>]
    where C0: Sequence, C1: Sequence, C2: Sequence, C3: Sequence, C4: Sequence, C5: Sequence, C6: Sequence, C7: Sequence, C8: Sequence
    {
        c0.map(Either.left) + buildBlock(c1, c2, c3, c4, c5, c6, c7, c8).map(Either.right)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9)
    -> [S9<C0.Element, C1.Element, C2.Element, C3.Element, C4.Element, C5.Element, C6.Element, C7.Element, C8.Element, C9.Element>]
    where C0: Sequence, C1: Sequence, C2: Sequence, C3: Sequence, C4: Sequence, C5: Sequence, C6: Sequence, C7: Sequence, C8: Sequence, C9: Sequence
    {
        c0.map(Either.left) + buildBlock(c1, c2, c3, c4, c5, c6, c7, c8, c9).map(Either.right)
    }
}
