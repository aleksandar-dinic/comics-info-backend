//
//  ComicSummaryFuturesFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol ComicSummaryFuturesFactory: ItemSummaryDatabaseItemFactory, ItemMetadataHandler {

    var comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>> { get }
    
    func getComics(_ comicsID: Set<String>?, from table: String) -> EventLoopFuture<[Comic]>
    
}

extension ComicSummaryFuturesFactory {
    
    func getComics(_ comicsID: Set<String>?, from table: String) -> EventLoopFuture<[Comic]> {
        guard let comicsID = comicsID, !comicsID.isEmpty else {
            return handleEmptyItems()
        }

        return comicUseCase.getAllMetadata(withIDs: comicsID, fromDataSource: .memory, from: table)
                .flatMapThrowing { try handleItems($0, itemsID: comicsID) }
    }
    
}
