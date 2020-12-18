//
//  CharactersSummaryDatabaseItemFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol CharactersSummaryDatabaseItemFactory {

    var encoderService: EncoderService { get }

    func makeCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item,
        in table: String
    ) -> [DatabasePutItem] where Item.ID == String

    func makeCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item,
        in table: String
    ) -> [DatabaseUpdateItem] where Item.ID == String

}

extension CharactersSummaryDatabaseItemFactory {

    func makeCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item,
        in table: String
    ) -> [DatabasePutItem] where Item.ID == String {
        var items = [DatabasePutItem]()

        for character in characters {
            let characterSummary = CharacterSummary(character, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(characterSummary, table: table))
        }

        return items
    }

    func makeCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item,
        in table: String
    ) -> [DatabaseUpdateItem] where Item.ID == String {
        var items = [DatabaseUpdateItem]()

        for character in characters {
            let characterSummary = CharacterSummary(character, id: item.id, itemName: .getType(from: Item.self))
            items.append(encoderService.encode(characterSummary, table: table, conditionExpression: nil))
        }

        return items
    }

}
