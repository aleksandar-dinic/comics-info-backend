//
//  CreateCharactersSummaryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol CreateCharactersSummaryAPIWrapper {

    var encoderService: EncoderService { get }

    func createCharactersSummary<Item: Identifiable>(
        _ characters: [Character],
        item: Item
    ) -> [DatabaseItem] where Item.ID == String

}

extension CreateCharactersSummaryAPIWrapper {

    func createCharactersSummary<Item: Identifiable>(
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

}
