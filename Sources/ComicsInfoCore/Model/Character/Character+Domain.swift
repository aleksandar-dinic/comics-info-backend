//
//  Character+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import Foundation

extension Character {
    
    init(from character: Domain.Character) {
        var seriesID: Set<String>?
        if let IDs = character.series?.map({ $0.identifier }), !IDs.isEmpty {
            seriesID = Set(IDs)
        }
        var seriesSummary: [SeriesSummary<Character>]?
        if let series = character.series?.map({ SeriesSummary<Character>(from: $0, id: character.identifier) }), !series.isEmpty {
            seriesSummary = series
        }
        var comicsID: Set<String>?
        if let IDs = character.comics?.map({ $0.identifier }), !IDs.isEmpty {
            comicsID = Set(IDs)
        }
        var comicSummary: [ComicSummary<Character>]?
        if let comics = character.comics?.map({ ComicSummary<Character>(from: $0, id: character.identifier, number: nil) }), !comics.isEmpty {
            comicSummary = comics
        }
                
        self.init(
            id: character.identifier,
            popularity: character.popularity,
            name: character.name,
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: character.thumbnail,
            description: character.description,
            realName: character.realName,
            aliases: character.aliases,
            birth: character.birth,
            seriesID: seriesID,
            series: seriesSummary,
            characterSummaryForSeries: nil,
            comicsID: comicsID,
            comics: comicSummary,
            characterSummaryForComics: nil,
            itemID: "\(String.getType(from: Character.self))#\(character.identifier)",
            summaryID: "\(String.getType(from: Character.self))#\(character.identifier)",
            itemName: .getType(from: Character.self)
        )
    }
    
}
