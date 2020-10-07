//
//  EncoderService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol EncoderService {

    func encode<Item: DatabaseDecodable>(_ item: Item) -> DatabasePutItem

    func encode<Item: DatabaseDecodable>(_ item: Item, conditionExpression: String?) -> DatabaseUpdateItem

}

extension EncoderService {

    public func encode<Item: DatabaseDecodable>(_ item: Item) -> DatabasePutItem {
        let mirror = Mirror(reflecting: item)
        var databaseItem = DatabasePutItem(table: item.tableName)

        for child in mirror.children {
            guard let label = child.label else { continue }
            if case Optional<Any>.none = child.value { continue }
            databaseItem[label] = child.value
        }

        return databaseItem
    }

    public func encode<Item: DatabaseDecodable>(
        _ item: Item,
        conditionExpression: String? = "attribute_exists(itemID) AND attribute_exists(summaryID)"
    ) -> DatabaseUpdateItem {

        let mirror = Mirror(reflecting: item)
        var databaseItem = DatabaseUpdateItem(
            table: item.tableName,
            itemID: item.itemID,
            summaryID: item.summaryID,
            conditionExpression: conditionExpression
        )

        for child in mirror.children {
            guard let label = child.label, label != "itemID", label != "summaryID" else { continue }
            if case Optional<Any>.none = child.value { continue }
            databaseItem[label] = child.value
        }

        return databaseItem
    }

}
