//
//  Series+Domain.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import Foundation

extension Series {
    
    init(from series: Domain.Series) {
        var charactersID: Set<String>?
        if let IDs = series.characters?.map({ $0.identifier }), !IDs.isEmpty {
            charactersID = Set(IDs)
        }
        var characterSummary: [CharacterSummary<Series>]?
        if let characters = series.characters?.map({ CharacterSummary<Series>(from: $0, id: series.identifier, count: nil) }), !characters.isEmpty {
            characterSummary = characters
        }
        var comicsID: Set<String>?
        if let IDs = series.comics?.map({ $0.identifier }), !IDs.isEmpty {
            comicsID = Set(IDs)
        }
        var comicSummary: [ComicSummary<Series>]?
        if let comics = series.comics?.map({ ComicSummary<Series>(from: $0, id: series.identifier, number: nil) }), !comics.isEmpty {
            comicSummary = comics
        }
        
        self.init(
            id: series.identifier,
            popularity: series.popularity,
            title: series.title,
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: series.thumbnail,
            description: series.description,
            startYear: series.startYear,
            endYear: series.endYear,
            aliases: series.aliases,
            nextIdentifier: series.nextIdentifier,
            charactersID: charactersID,
            characters: characterSummary,
            seriesSummaryForCharacters: nil,
            comicsID: comicsID,
            comics: comicSummary,
            seriesSummaryForComics: nil,
            itemID: "\(String.getType(from: Series.self))#\(series.identifier)",
            summaryID: "\(String.getType(from: Series.self))#\(series.identifier)",
            itemName: .getType(from: Series.self)
        )
    }
    
}
