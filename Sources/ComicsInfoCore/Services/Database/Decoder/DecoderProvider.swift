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

    public func decode<Item: DatabaseDecodable>(from item: DatabaseItem) throws -> Item {
        return try Item(from: item, tableName: item.table)
    }

}

