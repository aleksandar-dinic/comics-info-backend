//
//  ComicSummaryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol ComicSummaryFactory: MissingIDsHandler, SummariesFactory {
    
    var comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>> { get }
    
}

extension ComicSummaryFactory {
    
    func getComics(
        on eventLoop: EventLoop,
        forIDs comicsID: Set<String>?,
        from table: String
    ) -> EventLoopFuture<[Comic]> {
        guard let comicsID = comicsID else {
            return eventLoop.submit { [] }
        }
        
        return comicUseCase.getItems(on: eventLoop, withIDs: comicsID, from: table)
            .flatMapThrowing { try handleMissingIDs($0, IDs: comicsID) }
    }
    
}
