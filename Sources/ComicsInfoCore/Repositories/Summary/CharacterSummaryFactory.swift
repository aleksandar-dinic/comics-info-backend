//
//  CharacterSummaryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CharacterSummaryFactory: MissingIDsHandler, SummariesFactory {
    
    var characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>> { get }
    
}

extension CharacterSummaryFactory {
    
    func getCharacters(
        on eventLoop: EventLoop,
        forIDs charactersID: Set<String>?,
        from table: String
    ) -> EventLoopFuture<[Character]> {
        guard let charactersID = charactersID else {
            return eventLoop.submit { [] }
        }
        
        return characterUseCase.getItems(on: eventLoop, withIDs: charactersID, from: table)
            .flatMapThrowing { try handleMissingIDs($0, IDs: charactersID) }
    }
    
}
