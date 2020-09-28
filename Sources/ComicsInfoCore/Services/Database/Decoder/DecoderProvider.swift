//
//  DecoderProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct DecoderProvider: DecoderService {

    public init() {}

    public func decodeAll<Item: DatabaseDecodable>(from items: [[String: Any]]?) throws -> [Item] {
        guard let items = items else {
            throw APIError.itemsNotFound
        }

        return try items.compactMap { try Item(from: $0) }
    }

    public func decode<Item: DatabaseDecodable>(from items: [String: Any]?) throws -> Item {
        guard let items = items else {
            throw APIError.itemNotFound
        }
        return try Item(from: items)
    }

}

