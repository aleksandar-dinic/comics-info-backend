//
//  DecodingErrorFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

enum DecodingErrorFactory {
    
    static func makeNotFound(_ key: CodingKey) -> DecodingError {
        DecodingError.keyNotFound(
            key,
            DecodingError.Context(
                codingPath: [key],
                debugDescription: "No value associated with key \(key)"
            )
        )
    }
    
    static func makeTypeMismatch<T>(_ type: T.Type, forKey key: CodingKey, item: Any) -> DecodingError {
        DecodingError.typeMismatch(
            T.self,
            DecodingError.Context(
                codingPath: [key],
                debugDescription: "Expected to decode \(T.self) but found a \(Swift.type(of: item)) instead."
            )
        )
    }
    
    static func makeDataCorrupted(forKey key: CodingKey, item: Any) -> DecodingError {
        DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: [key],
                debugDescription: "Invalid date format: \(item)."
            )
        )
    }
    
}
