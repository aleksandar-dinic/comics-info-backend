//
//  CreateSeriesSummaryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol CreateSeriesSummaryAPIWrapper {

    var encoderService: EncoderService { get }

    func createSeriesSummary<Item: Identifiable>(
        _ series: [Series],
        item: Item
    ) -> [DatabaseItem] where Item.ID == String

}

extension CreateSeriesSummaryAPIWrapper {

    func createSeriesSummary<Item: Identifiable>(
        _ series: [Series],
        item: Item
    ) -> [DatabaseItem] where Item.ID == String {
        var items = [DatabaseItem]()

        for series in series {
            let seriesSummary = SeriesSummary(series, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(seriesSummary, table: .seriesTableName))
        }

        return items
    }

}
