//
//  CharactersMetadataHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CharactersMetadataHandler: EmptyItemsHandler {

    var characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> { get }

    func getCharacters(_ charactersID: Set<String>?) -> EventLoopFuture<[Character]>

}

extension CharactersMetadataHandler {

    func getCharacters(_ charactersID: Set<String>?) -> EventLoopFuture<[Character]> {
        guard let charactersID = charactersID, !charactersID.isEmpty else {
            return handleEmptyItems()
        }

        return characterUseCase.getAllMetadata(withIDs: charactersID, fromDataSource: .memory)
                .flatMapThrowing { try handleItems($0, itemsID: charactersID) }
    }

    private func handleItems<Item: Identifiable>(_ items: [Item], itemsID: Set<Item.ID>) throws -> [Item] where Item.ID == String {
        let ids = Set(items.map { $0.id })
        for id in itemsID {
            guard !ids.contains(id) else { continue }
            throw APIError.itemNotFound(withID: id, itemType: Item.self)
        }
        return items
    }

}
