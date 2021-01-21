//
//  ItemSummaryDatabaseItemFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 21/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol ItemSummaryDatabaseItemFactory {

    var encoderService: EncoderService { get }

    func makeItemSummary<ItemsSummary: SummaryMapper, Item: Identifiable>(
        _ itemsSummary: [ItemsSummary],
        item: Item,
        in table: String
    ) -> [DatabasePutItem] where Item.ID == String

    func makeItemSummary<ItemsSummary: SummaryMapper, Item: Identifiable>(
        _ itemsSummary: [ItemsSummary],
        item: Item,
        in table: String
    ) -> [DatabaseUpdateItem] where Item.ID == String

}

extension ItemSummaryDatabaseItemFactory {

    func makeItemSummary<ItemsSummary: SummaryMapper, Item: Identifiable>(
        _ itemsSummary: [ItemsSummary],
        item: Item,
        in table: String
    ) -> [DatabasePutItem] where Item.ID == String {
        var items = [DatabasePutItem]()

        for itemSummary in itemsSummary {
            let comicSummary = ItemSummary(itemSummary, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(comicSummary, table: table))
        }

        return items
    }

    func makeItemSummary<ItemsSummary: SummaryMapper, Item: Identifiable>(
        _ itemsSummary: [ItemsSummary],
        item: Item,
        in table: String
    ) -> [DatabaseUpdateItem] where Item.ID == String {
        var items = [DatabaseUpdateItem]()

        for itemSummary in itemsSummary {
            let comicSummary = ItemSummary(itemSummary, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(comicSummary, table: table, conditionExpression: nil))
        }

        return items
    }

}
