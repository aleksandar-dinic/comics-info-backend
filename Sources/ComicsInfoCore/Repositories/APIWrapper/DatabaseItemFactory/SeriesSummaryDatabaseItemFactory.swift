//
//  SeriesSummaryDatabaseItemFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol SeriesSummaryDatabaseItemFactory {

    var encoderService: EncoderService { get }

    func makeSeriesSummary<Item: Identifiable>(
        _ series: [Series],
        item: Item,
        in table: String
    ) -> [DatabasePutItem] where Item.ID == String

    func makeSeriesSummary<Item: Identifiable>(
        _ series: [Series],
        item: Item,
        in table: String
    ) -> [DatabaseUpdateItem] where Item.ID == String

}

extension SeriesSummaryDatabaseItemFactory {

    func makeSeriesSummary<Item: Identifiable>(
        _ series: [Series],
        item: Item,
        in table: String
    ) -> [DatabasePutItem] where Item.ID == String {
        var items = [DatabasePutItem]()

        for series in series {
            let seriesSummary = SeriesSummary(series, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(seriesSummary, table: table))
        }

        return items
    }

    func makeSeriesSummary<Item: Identifiable>(
        _ series: [Series],
        item: Item,
        in table: String
    ) -> [DatabaseUpdateItem] where Item.ID == String {
        var items = [DatabaseUpdateItem]()

        for series in series {
            let seriesSummary = SeriesSummary(series, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(seriesSummary, table: table, conditionExpression: nil))
        }

        return items
    }

}
