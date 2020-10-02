//
//  EncoderProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct EncoderProvider: EncoderService {

    public init() {}

    public func encode<Item>(_ item: Item, table: String) -> DatabaseItem {
        let mirror = Mirror(reflecting: item)
        var databaseItem = DatabaseItem(table: table)

        for child in mirror.children {
            guard let label = child.label else { continue }
            if case Optional<Any>.none = child.value { continue }
            databaseItem[label] = child.value
        }

        return databaseItem
    }

}
