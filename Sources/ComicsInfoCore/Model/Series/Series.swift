//
//  Series.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Series: SummaryMapper {

    /// The unique ID of the series resource.
    public let id: String

    /// The value of Series popularity
    public private(set) var popularity: Int

    /// The canonical title of the series.
    private(set) var title: String
    
    /// Date the series was added to Comic Info.
    let dateAdded: Date
    
    /// Date the series was last updated on Comic Info.
    private(set) var dateLastUpdated: Date

    /// The representative image for this series.
    public private(set) var thumbnail: String?

    /// A description of the series.
    public private(set) var description: String?

    /// The first year of publication for the series.
    private(set) var startYear: Int?

    /// The last year of publication for the series (conventionally, nil for ongoing series) .
    private(set) var endYear: Int?
    
    /// List of aliases the series is known by.
    private(set) var aliases: [String]?

    /// ID of the series which follows this series.
    private(set) var nextIdentifier: String?

    /// A resource list containing charactersID which appear in comics in this series.
    var charactersID: Set<String>?

    /// A resource list containing characters which appear in comics in this series.
    var characters: [CharacterSummary]?
    var seriesSummaryForCharacters: [SeriesSummary]?

    /// A resource list containing comicsID in this series.
    var comicsID: Set<String>?

    /// A resource list containing comics in this series.
    var comics: [ComicSummary]?
    var seriesSummaryForComics: [SeriesSummary]?
    
    public let itemID: String
    public let summaryID: String
    public let itemName: String
    
    public var name: String {
        title
    }
    
}

extension Series {
    
    public mutating func update(with newItem: Series) {
        popularity = newItem.popularity
        title = newItem.title
        dateLastUpdated = Date()
        
        if let thumbnail = newItem.thumbnail {
            self.thumbnail = thumbnail
        }
        if let description = newItem.description {
            self.description = description
        }
        if let startYear = newItem.startYear {
            self.startYear = startYear
        }
        if let endYear = newItem.endYear {
            self.endYear = endYear
        }

        aliases = update(aliases, with: newItem.aliases)

        if let nextIdentifier = newItem.nextIdentifier {
            self.nextIdentifier = nextIdentifier
        }
        charactersID = newItem.comicsID
        characters = newItem.characters
        seriesSummaryForCharacters = newItem.seriesSummaryForCharacters
        comicsID = newItem.comicsID
        comics = newItem.comics
        seriesSummaryForComics = newItem.seriesSummaryForComics
    }
    
}

extension Series {
    
    enum CodingKeys: String, CodingKey {
        case id
        case popularity
        case title
        case dateAdded
        case dateLastUpdated
        case thumbnail
        case description
        case startYear
        case endYear
        case aliases
        case nextIdentifier
        case itemID
        case summaryID
        case itemName
    }
    
}
