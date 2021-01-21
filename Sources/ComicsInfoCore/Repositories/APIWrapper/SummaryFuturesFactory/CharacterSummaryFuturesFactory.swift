//
//  CharacterSummaryFuturesFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CharacterSummaryFuturesFactory: ItemSummaryDatabaseItemFactory, ItemMetadataHandler {
    
    var characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> { get }
    
    func getCharacters(_ charactersID: Set<String>?, from table: String) -> EventLoopFuture<[Character]>
    
}

extension CharacterSummaryFuturesFactory {
    
    func getCharacters(_ charactersID: Set<String>?, from table: String) -> EventLoopFuture<[Character]> {
        guard let charactersID = charactersID, !charactersID.isEmpty else {
            return handleEmptyItems()
        }

        return characterUseCase.getAllMetadata(withIDs: charactersID, fromDataSource: .memory, from: table)
                .flatMapThrowing { try handleItems($0, itemsID: charactersID) }
    }

}
