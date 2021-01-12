//
//  DatabaseDecoder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct DatabaseDecoder {

    private let item: DatabaseItem

    public init(from item: DatabaseItem) {
        self.item = item
    }

    public func decode<T>(_ type: T.Type, forKey key: CodingKey) throws -> T {
        guard let item = item[key.stringValue] else {
            throw DecodingErrorFactory.makeNotFound(key)
        }

        if type is Date.Type, let date = try decodeDate(item, forKey: key) as? T {
            return date
        }

        guard let decodeItem = item as? T else {
            throw DecodingErrorFactory.makeTypeMismatch(T.self, forKey: key, item: item)
        }

        return decodeItem
    }
    
    private func decodeDate(_ item: Any, forKey key: CodingKey) throws -> Date {
        guard let decodeItem = item as? String else {
            throw DecodingErrorFactory.makeTypeMismatch(Date.self, forKey: key, item: item)
        }
        
        guard let date = DateFormatter.defaultDate(from: decodeItem) else {
            throw DecodingErrorFactory.makeDataCorrupted(forKey: key, item: item)
        }
        
        return date
    }

}
