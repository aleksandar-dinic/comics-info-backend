//
//  CreateComicsSummaryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol CreateComicsSummaryAPIWrapper {

    var encoderService: EncoderService { get }

    func createComicsSummary<Item: Identifiable>(
        _ comics: [Comic],
        item: Item
    ) -> [DatabaseItem] where Item.ID == String

}

extension CreateComicsSummaryAPIWrapper {

    func createComicsSummary<Item: Identifiable>(
        _ comics: [Comic],
        item: Item
    ) -> [DatabaseItem] where Item.ID == String {
        var items = [DatabaseItem]()

        for comic in comics {
            let comicSummary = ComicSummary(comic, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(comicSummary, table: .comicTableName))
        }

        return items
    }

}
