//
//  CreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

protocol CreateAPIWrapper {

    associatedtype Item

    var repositoryAPIService: RepositoryAPIService { get }
    var encoderService: EncoderService { get }
    var eventLoop: EventLoop { get }

    func create(_ item: Item) -> EventLoopFuture<Void>

    func appendCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item
    ) -> [DatabaseItem] where Item.ID == String

    func appendSeriesSummary<Item: Identifiable>(
        _ series: [Series],
        item: Item
    ) -> [DatabaseItem] where Item.ID == String

}

extension CreateAPIWrapper {

    func appendCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item
    ) -> [DatabaseItem] where Item.ID == String {
        var items = [DatabaseItem]()

        for character in characters {
            let characterSummary = CharacterSummary(character, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(characterSummary, table: .characterTableName))
        }

        return items
    }

    func appendSeriesSummary<Item: Identifiable>(
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
