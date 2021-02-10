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
                    let summaries = self.makeComicSummaries(item, link: characters)
                    
                    if item.comicSummaries == nil {
                        item.comicSummaries = [ComicSummary]()
                    }
                    item.comicSummaries?.append(contentsOf: summaries)
                }

                if !series.isEmpty {
                    item.series = self.makeSeriesSummaries(series, link: item)
                    let summaries = self.makeComicSummaries(item, link: series)
                    
                    if item.comicSummaries == nil {
                        item.comicSummaries = [ComicSummary]()
                    }
                    item.comicSummaries?.append(contentsOf: summaries)
                }
                
                return item
            }
    }
    
}
