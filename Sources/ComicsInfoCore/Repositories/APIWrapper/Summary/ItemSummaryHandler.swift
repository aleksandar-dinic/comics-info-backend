//
//  ItemSummaryHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 21/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol ItemSummaryHandler {

    var decoderService: DecoderService { get }

    func handleItemSummary<Item: SummaryMapper>(_ items: [DatabaseItem]) -> [ItemSummary<Item>]?

}

extension ItemSummaryHandler {

    func handleItemSummary<Item: SummaryMapper>(_ items: [DatabaseItem]) -> [ItemSummary<Item>]? {
        var itemsSummary = [ItemSummary<Item>]()

        for item in items {
            guard let itemSummary: ItemSummary<Item> = try? decoderService.decode(from: item) else { continue }
            itemsSummary.append(itemSummary)
        }

        return !itemsSummary.isEmpty ? itemsSummary : nil
    }

}
