//
//  EncoderService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol EncoderService {

    func encode<Item: DatabaseDecodable>(_ item: Item, table: String) -> DatabasePutItem

    func encode<Item: DatabaseDecodable>(
        _ item: Item,
        table: String,
        conditionExpression: String?
    ) -> DatabaseUpdateItem

}

extension EncoderService {

    public func encode<Item: DatabaseDecodable>(_ item: Item, table: String) -> DatabasePutItem {
        let mirror = Mirror(reflecting: item)
        var databaseItem = DatabasePutItem(table: table)

        for child in mirror.children {
            guard let label = child.label else { continue }
            if case Optional<Any>.none = child.value { continue }
            databaseItem[label] = child.value
        }

        return databaseItem
    }

    public func encode<Item: DatabaseDecodable>(
        _ item: Item,
        table: String,
        conditionExpression: String? = "attribute_exists(itemID) AND attribute_exists(summaryID)"
    ) -> DatabaseUpdateItem {

        let mirror = Mirror(reflecting: item)
        var databaseItem = DatabaseUpdateItem(
            table: table,
            itemID: item.itemID,
            summaryID: item.summaryID,
            conditionExpression: conditionExpression
        )

        for child in mirror.children {
            guard let label = child.label, !item.notUpdatableFields.contains(label) else { continue }
            if case Optional<Any>.none = child.value { continue }
            databaseItem[label] = child.value
        }

        return databaseItem
    }

}
