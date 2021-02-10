//
//  Character+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import Foundation

extension Domain.Character: Identifiable {
    
    public var id: String {
        identifier
    }
    
}

extension Character {
    
    init(from character: Domain.Character) {
        var seriesID: Set<String>?
        if let IDs = character.series?.map({ $0.identifier }), !IDs.isEmpty {
            seriesID = Set(IDs)
        }
        var seriesSummary: [SeriesSummary]?
        if let series = character.series?.map({ SeriesSummary(from: $0, link: character) }), !series.isEmpty {
            seriesSummary = series
        }
        var comicsID: Set<String>?
        if let IDs = character.comics?.map({ $0.identifier }), !IDs.isEmpty {
            comicsID = Set(IDs)
        }
        var comicSummary: [ComicSummary]?
        if let comics = character.comics?.map({ ComicSummary(from: $0, link: character, number: nil) }), !comics.isEmpty {
            comicSummary = comics
        }
                
        let now = Date()
        self.init(
            id: character.identifier,
            popularity: character.popularity,
            name: character.name,
            dateAdded: now,
            dateLastUpdated: now,
            thumbnail: character.thumbnail,
            description: character.description,
            realName: character.realName,
            aliases: character.aliases,
            birth: character.birth,
            seriesID: seriesID,
            series: seriesSummary,
            comicsID: comicsID,
            comics: comicSummary,
            itemID: .comicInfoID(for: character),
            summaryID: .comicInfoID(for: character),
            itemName: .getType(from: Character.self),
            characterSummaries: nil
        )
    }
    
}
