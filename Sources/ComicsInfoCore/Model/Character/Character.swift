//
//  Character.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Character: SummaryMapper {

    /// The unique ID of the character resource.
    public var id: String {
        itemID.getIDFromComicInfoID(for: Character.self)
    }

    /// The value of character popularity
    public private(set) var popularity: Int

    /// The name of the character.
    public private(set) var name: String
    
    /// Date the character was added to Comic Info.
    let dateAdded: Date
    
    /// Date the character was last updated on Comic Info.
    private(set) var dateLastUpdated: Date

    /// The representative image for this character.
    public private(set) var thumbnail: String?

    ///  A short bio or description of the character
    public private(set) var description: String?
    
    /// Real name of the character.
    private(set) var realName: String?
    
    /// List of aliases the character is known by.
    private(set) var aliases: [String]?
    
    /// A date, that the character was born on. Not an origin date.
    private(set) var birth: Date?

    /// A resource list of the main seriesID of this character.
    private(set) var mainSeriesID: Set<String>?

    /// A resource list of the main series of this character.
    var mainSeries: [SeriesSummary]?
    
    /// A resource list of seriesID in which this character appears.
    private(set) var seriesID: Set<String>?

    /// A resource list of series in which this character appears.
    var series: [SeriesSummary]?

    /// A resource list containing comicsID which feature this character.
    private(set) var comicsID: Set<String>?

    /// A resource list containing comics which feature this character.
    var comics: [ComicSummary]?
    
    public let itemID: String
    public let itemType: String
    public private(set) var sortValue: String
    
    init(
        id: String,
        popularity: Int,
        name: String,
        thumbnail: String?,
        description: String?,
        realName: String?,
        aliases: [String]?,
        birth: Date?,
        mainSeriesID: Set<String>?,
        seriesID: Set<String>?,
        comicsID: Set<String>?
    ) {
        let now = Date()
        
        self.popularity = popularity
        self.name = name
        dateAdded = now
        dateLastUpdated = now
        self.thumbnail = thumbnail
        self.description = description
        self.realName = realName
        self.aliases = aliases
        self.birth = birth
        self.mainSeriesID = mainSeriesID
        self.seriesID = seriesID
        self.comicsID = comicsID
        itemID = .comicInfoID(for: Character.self, ID: id)
        itemType = .getType(from: Character.self)
        sortValue = "Popularity=\(abs(popularity-100))#Name=\(name)"
    }
    
}

extension Character {
    
    public mutating func update(with newItem: Character) {
        popularity = newItem.popularity
        name = newItem.name
        dateLastUpdated = Date()
        if let thumbnail = newItem.thumbnail {
            self.thumbnail = thumbnail
        }
        if let description = newItem.description {
            self.description = description
        }
        if let realName = newItem.realName {
            self.realName = realName
        }
        aliases = update(aliases, with: newItem.aliases)
        
        if let birth = newItem.birth {
            self.birth = birth
        }
        mainSeriesID = newItem.mainSeriesID
        var newMainSeries = mainSeries ?? []
        for series in newItem.mainSeries ?? [] {
            guard !newMainSeries.contains(series) else { continue }
            newMainSeries.append(series)
        }
        mainSeries = newMainSeries
        seriesID = newItem.seriesID
        series = newItem.series
        comicsID = newItem.comicsID
        comics = newItem.comics
        sortValue = "Popularity=\(abs(popularity-100))#Name=\(name)"
    }

}

extension Character {
    
    enum CodingKeys: String, CodingKey {
        case popularity
        case name
        case dateAdded
        case dateLastUpdated
        case thumbnail
        case description
        case realName
        case aliases
        case birth
        case mainSeries
        case itemID
        case itemType
        case sortValue
    }
        
}
