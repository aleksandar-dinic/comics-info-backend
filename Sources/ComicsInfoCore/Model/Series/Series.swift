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
    public let popularity: Int

    /// The canonical title of the series.
    let title: String
    
    /// Date the series was added to Comic Info.
    let dateAdded: Date
    
    /// Date the series was last updated on Comic Info.
    let dateLastUpdated: Date

    /// The representative image for this series.
    public let thumbnail: String?

    /// A description of the series.
    public let description: String?

    /// The first year of publication for the series.
    let startYear: Int?

    /// The last year of publication for the series (conventionally, nil for ongoing series) .
    let endYear: Int?
    
    /// List of aliases the series is known by.
    let aliases: [String]?

    /// ID of the series which follows this series.
    let nextIdentifier: String?

    /// A resource list containing charactersID which appear in comics in this series.
    var charactersID: Set<String>?

    /// A resource list containing characters which appear in comics in this series.
    var characters: [CharacterSummary<Series>]?
    var seriesSummaryForCharacters: [SeriesSummary<Character>]?

    /// A resource list containing comicsID in this series.
    var comicsID: Set<String>?

    /// A resource list containing comics in this series.
    var comics: [ComicSummary<Series>]?
    var seriesSummaryForComics: [SeriesSummary<Comic>]?
    
    public let itemID: String
    public let summaryID: String
    public let itemName: String
    
    public var name: String {
        title
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
