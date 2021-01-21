//
//  Character.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Character: ComicsInfoItem, SummaryMapper {

    /// The unique ID of the character resource.
    public let id: String

    /// The value of character popularity
    let popularity: Int

    /// The name of the character.
    let name: String
    
    /// Date the character was added to Comic Info.
    let dateAdded: Date
    
    /// Date the character was last updated on Comic Info.
    let dateLastUpdated: Date

    /// The representative image for this character.
    let thumbnail: String?

    ///  A short bio or description of the character
    let description: String?
    
    /// Real name of the character.
    let realName: String?
    
    /// List of aliases the character is known by.
    let aliases: [String]?
    
    /// A date, that the character was born on. Not an origin date.
    let birth: Date?

    /// A resource list of seriesID in which this character appears.
    var seriesID: Set<String>?

    /// A resource list of series in which this character appears.
    let series: [ItemSummary<Series>]?

    /// A resource list containing comicsID which feature this character.
    var comicsID: Set<String>?

    /// A resource list containing comics which feature this character.
    let comics: [ItemSummary<Comic>]?

    mutating func removeID(_ itemID: String) {
        if itemID.starts(with: String.getType(from: Series.self)) {
            let id = itemID.dropFirst("\(String.getType(from: Series.self))#".count)
            seriesID?.remove(String(id))
        } else if itemID.starts(with: String.getType(from: Comic.self)) {
            let id = itemID.dropFirst("\(String.getType(from: Comic.self))#".count)
            comicsID?.remove(String(id))
        }
    }

}

extension Character {
    
    enum CodingKeys: String, CodingKey {
        case id
        case popularity
        case name
        case thumbnail
        case description
        case realName
        case aliases
        case birth
        case seriesID
        case series
        case comicsID
        case comics
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        popularity = try values.decode(Int.self, forKey: .popularity)
        name = try values.decode(String.self, forKey: .name)
        dateAdded = Date()
        dateLastUpdated = Date()
        thumbnail = try? values.decode(String.self, forKey: .thumbnail)
        description = try? values.decode(String.self, forKey: .description)
        realName = try? values.decode(String.self, forKey: .realName)
        aliases = try? values.decode([String].self, forKey: .aliases)
        birth = try? values.decode(Date.self, forKey: .birth)
        seriesID = try? values.decode(Set<String>.self, forKey: .seriesID)
        series = try? values.decode([ItemSummary<Series>].self, forKey: .series)
        comicsID = try? values.decode(Set<String>.self, forKey: .comicsID)
        comics = try? values.decode([ItemSummary<Comic>].self, forKey: .comics)
    }
    
}
