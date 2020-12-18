//
//  ComicSummaryDatabaseItemFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol ComicSummaryDatabaseItemFactory {

    var encoderService: EncoderService { get }

    func makeComicsSummary<Item: Identifiable>(
        _ comics: [Comic],
        item: Item,
        in table: String
    ) -> [DatabasePutItem] where Item.ID == String

    func makeComicsSummary<Item: Identifiable>(
        _ comics: [Comic],
        item: Item,
        in table: String
    ) -> [DatabaseUpdateItem] where Item.ID == String

}

extension ComicSummaryDatabaseItemFactory {

    func makeComicsSummary<Item: Identifiable>(
        _ comics: [Comic],
        item: Item,
        in table: String
    ) -> [DatabasePutItem] where Item.ID == String {
        var items = [DatabasePutItem]()

        for comic in comics {
            let comicSummary = ComicSummary(comic, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(comicSummary, table: table))
        }

        return items
    }

    func makeComicsSummary<Item: Identifiable>(
        _ comics: [Comic],
        item: Item,
        in table: String
    ) -> [DatabaseUpdateItem] where Item.ID == String {
        var items = [DatabaseUpdateItem]()

        for comic in comics {
            let comicSummary = ComicSummary(comic, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(comicSummary, table: table, conditionExpression: nil))
        }

        return items
    }

}
