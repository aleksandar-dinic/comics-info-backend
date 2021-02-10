//
//  ComicAddSummariesFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 10/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol ComicAddSummariesFactory: CharacterSummaryFactory, SeriesSummaryFactory {
    
    func addSummaries(to item: Comic, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Comic>
    
}

extension ComicAddSummariesFactory {
    
    public func addSummaries(to item: Comic, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Comic> {
        getCharacters(on: eventLoop, forIDs: item.charactersID, from: table)
            .and(getSeries(on: eventLoop, forIDs: item.seriesID, from: table))
            .flatMapThrowing { characters, series in
                var item = item
                
                if !characters.isEmpty {
                    item.characters = self.makeCharacterSummaries(characters, link: item, count: nil)
                    item.comicSummaryForCharacters = self.makeComicSummaries(item, link: characters)
                }

                if !series.isEmpty {
                    item.series = self.makeSeriesSummaries(series, link: item)
                    item.comicSummaryForSeries = self.makeComicSummaries(item, link: series)
                }
                
                return item
            }
    }
    
}
