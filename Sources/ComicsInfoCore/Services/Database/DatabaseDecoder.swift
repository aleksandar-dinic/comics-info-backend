//
//  DatabaseDecoder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct DatabaseDecoder {

    private let items: [String: Any]

    init(from items: [String: Any]) {
        self.items = items
    }

    func decode<T>(_ type: T.Type, forKey key: String) throws -> T {
        guard let item = items[key] else {
            throw APIError.decodingError(.keyNotFound(key))
        }

        guard let decodeItem = item as? T else {
            throw APIError.decodingError(.typeMismatch(forKey: key))
        }

        return decodeItem
    }

}
