//
//  CharacterAddSummariesFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 10/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CharacterAddSummariesFactory: SeriesSummaryFactory, ComicSummaryFactory {
    
    func addSummaries(to item: Character, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Character>
    
}

extension CharacterAddSummariesFactory {
    
    public func addSummaries(to item: Character, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Character> {
        getSeries(on: eventLoop, forIDs: item.seriesID, from: table)
            .and(getComics(on: eventLoop, forIDs: item.comicsID, from: table))
            .flatMapThrowing { series, comics in
                var item = item
                
                if !series.isEmpty {
                    item.series = self.makeSeriesSummaries(series, link: item)
                    item.characterSummaryForSeries = self.makeCharacterSummaries(item, link: series, count: nil)
                }
                
                if !comics.isEmpty {
                    item.comics = self.makeComicSummaries(comics, link: item)
                    item.characterSummaryForComics = self.makeCharacterSummaries(item, link: comics, count: nil)
                }
                
                return item
            }
    }
    
}
