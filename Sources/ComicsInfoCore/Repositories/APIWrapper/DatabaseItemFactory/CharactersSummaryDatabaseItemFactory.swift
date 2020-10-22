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
    var tableName: String { get }

    func makeCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item
    ) -> [DatabasePutItem] where Item.ID == String

    func makeCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item
    ) -> [DatabaseUpdateItem] where Item.ID == String

}

extension CharactersSummaryDatabaseItemFactory {

    func makeCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item
    ) -> [DatabasePutItem] where Item.ID == String {
        var items = [DatabasePutItem]()

        for character in characters {
            let characterSummary = CharacterSummary(character, id: item.id, itemName: .getType(from: Item.self), tableName: tableName)
            items.append(encoderService.encode(characterSummary))
        }

        return items
    }

    func makeCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item
    ) -> [DatabaseUpdateItem] where Item.ID == String {
        var items = [DatabaseUpdateItem]()

        for character in characters {
            let characterSummary = CharacterSummary(character, id: item.id, itemName: .getType(from: Item.self), tableName: tableName)
            items.append(encoderService.encode(characterSummary, conditionExpression: nil))
        }

        return items
    }

}
