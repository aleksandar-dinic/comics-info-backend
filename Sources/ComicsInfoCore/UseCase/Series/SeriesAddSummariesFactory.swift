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
                    item.seriesSummaryForCharacters = self.makeSeriesSummaries(item, link: characters)
                }
                
                if !comics.isEmpty {
                    item.comics = self.makeComicSummaries(comics, link: item)
                    item.seriesSummaryForComics = self.makeSeriesSummaries(item, link: comics)
                }
                
                return item
            }
    }
    
}
