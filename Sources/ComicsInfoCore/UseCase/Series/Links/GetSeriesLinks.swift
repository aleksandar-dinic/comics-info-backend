//
//  GetSeriesLinks.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol GetSeriesLinks: GetSeriesSummaries, GetCharacters, GetComics {
    
    func getLinks(
        for item: Series,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<([Character], [Comic])>
    
}

extension GetSeriesLinks {
    
    func getLinks(
        for item: Series,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<([Character], [Comic])> {
        getCharacters(on: eventLoop, forIDs: item.charactersID, from: table)
            .and(getComics(on: eventLoop, forIDs: item.comicsID, from: table))
            .and(getSummaries(item, on: eventLoop, in: table))
            .flatMapThrowing { (arg0, summaries) -> ([Character], [Comic]) in
                let (characters, comics) = arg0
                guard let summaries = summaries else { return (characters, comics) }
                
                throw ComicInfoError.summariesAlreadyExist(Set(summaries.map { $0.itemID }))
            }
    }
    
}
