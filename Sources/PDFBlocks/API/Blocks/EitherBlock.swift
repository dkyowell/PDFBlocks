//
//  EitherBlock.swift
//
//
//  Created by David Yowell on 4/28/24.
//

import Foundation

/// A special block used by `@BlockBuilder` for constructing
/// blocks with if/else and switch statements. `EitherBlock`
/// cannot be constructed directly.
public struct EitherBlock<TrueContent, FalseContent>: Block where TrueContent: Block, FalseContent: Block {
    let value: Value

    enum Value {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }
}
