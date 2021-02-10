//
//  SeriesAddSummariesFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 10/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol SeriesAddSummariesFactory: CharacterSummaryFactory, ComicSummaryFactory {
    
    func addSummaries(to item: Series, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Series>
    
}

extension SeriesAddSummariesFactory {
    
    public func addSummaries(to item: Series, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Series> {
        getCharacters(on: eventLoop, forIDs: item.charactersID, from: table)
            .and(getComics(on: eventLoop, forIDs: item.comicsID, from: table))
            .flatMapThrowing { characters, comics in
                var item = item

                if !characters.isEmpty {
                    item.characters = self.makeCharacterSummaries(characters, link: item, count: nil)
                    let summaries = self.makeSeriesSummaries(item, link: characters)
                    
                    if item.seriesSummaries == nil {
                        item.seriesSummaries = [SeriesSummary]()
                    }
                    item.seriesSummaries?.append(contentsOf: summaries)
                }
                
                if !comics.isEmpty {
                    item.comics = self.makeComicSummaries(comics, link: item)
                    let summaries = self.makeSeriesSummaries(item, link: comics)
                    
                    if item.seriesSummaries == nil {
                        item.seriesSummaries = [SeriesSummary]()
                    }
                    item.seriesSummaries?.append(contentsOf: summaries)
                }
                
                return item
            }
    }
    
}
