//
//  Series+Domain.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import Foundation

extension Domain.Series: Identifiable {

    public var id: String {
        identifier
    }
    
}

extension Series {
    
    init(from series: Domain.Series) {
        var charactersID: Set<String>?
        if let IDs = series.characters?.map({ $0.identifier }), !IDs.isEmpty {
            charactersID = Set(IDs)
        }
        var characterSummary: [CharacterSummary]?
        if let characters = series.characters?.map({ CharacterSummary(from: $0, link: series, count: nil) }), !characters.isEmpty {
            characterSummary = characters
        }
        var comicsID: Set<String>?
        if let IDs = series.comics?.map({ $0.identifier }), !IDs.isEmpty {
            comicsID = Set(IDs)
        }
        var comicSummary: [ComicSummary]?
        if let comics = series.comics?.map({ ComicSummary(from: $0, link: series, number: nil) }), !comics.isEmpty {
            comicSummary = comics
        }
        
        let now = Date()
        self.init(
            id: series.identifier,
            popularity: series.popularity,
            title: series.title,
            dateAdded: now,
            dateLastUpdated: now,
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
            itemID: .comicInfoID(for: series),
            summaryID: .comicInfoID(for: series),
            itemName: .getType(from: Series.self)
        )
    }
    
}
