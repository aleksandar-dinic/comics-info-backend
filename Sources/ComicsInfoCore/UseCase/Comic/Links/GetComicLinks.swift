//
//  GetComicLinks.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol GetComicLinks: GetComicSummaries, GetCharacters, GetSeries {
    
    func getLinks(
        for item: Comic,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<([Character], [Series])>
    
}

extension GetComicLinks {
    
    func getLinks(
        for item: Comic,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<([Character], [Series])> {
        getCharacters(on: eventLoop, forIDs: item.charactersID, from: table)
            .and(getSeries(on: eventLoop, forIDs: item.seriesID, from: table))
            .and(getSummaries(item, on: eventLoop, in: table))
            .flatMapThrowing { (arg0, summaries) -> ([Character], [Series]) in
                let (characters, series) = arg0
                guard let summaries = summaries else { return (characters, series) }
                
                throw ComicInfoError.summariesAlreadyExist(Set(summaries.map { $0.itemID }))
            }
    }
    
}
