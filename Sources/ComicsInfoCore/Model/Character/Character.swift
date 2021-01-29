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
    public let popularity: Int

    /// The name of the character.
    public let name: String
    
    /// Date the character was added to Comic Info.
    let dateAdded: Date
    
    /// Date the character was last updated on Comic Info.
    let dateLastUpdated: Date

    /// The representative image for this character.
    public let thumbnail: String?

    ///  A short bio or description of the character
    public let description: String?
    
    /// Real name of the character.
    let realName: String?
    
    /// List of aliases the character is known by.
    let aliases: [String]?
    
    /// A date, that the character was born on. Not an origin date.
    let birth: Date?

    /// A resource list of seriesID in which this character appears.
    var seriesID: Set<String>?

    /// A resource list of series in which this character appears.
    var series: [SeriesSummary<Character>]?
    var characterSummaryForSeries: [CharacterSummary<Series>]?

    /// A resource list containing comicsID which feature this character.
    var comicsID: Set<String>?

    /// A resource list containing comics which feature this character.
    var comics: [ComicSummary<Character>]?
    var characterSummaryForComics: [CharacterSummary<Comic>]?
    
    public let itemID: String
    public let summaryID: String
    public let itemName: String
    
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
