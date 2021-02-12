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
    public let id: String

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

    /// A resource list of seriesID in which this character appears.
    var seriesID: Set<String>?

    /// A resource list of series in which this character appears.
    var series: [SeriesSummary]?

    /// A resource list containing comicsID which feature this character.
    var comicsID: Set<String>?

    /// A resource list containing comics which feature this character.
    var comics: [ComicSummary]?
    
    public let itemID: String
    public let summaryID: String
    public let itemName: String
    
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
        seriesID = newItem.seriesID
        series = newItem.series
        comicsID = newItem.comicsID
        comics = newItem.comics
    }

}

extension Character {
    
    enum CodingKeys: String, CodingKey {
        case id
        case popularity
        case name
        case dateAdded
        case dateLastUpdated
        case thumbnail
        case description
        case realName
        case aliases
        case birth
        case itemID
        case summaryID
        case itemName
    }
        
}
