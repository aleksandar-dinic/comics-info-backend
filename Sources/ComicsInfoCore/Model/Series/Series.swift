//
//  Series.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Series: ComicsInfoItem {

    /// The unique ID of the series resource.
    public let id: String

    /// The value of Series popularity
    let popularity: Int

    /// The canonical title of the series.
    let title: String
    
    /// Date the series was added to Comic Info.
    let dateAdded: Date
    
    /// Date the series was last updated on Comic Info.
    let dateLastUpdated: Date

    /// The representative image for this series.
    let thumbnail: String?

    /// A description of the series.
    let description: String?

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
    let characters: [Character]?

    /// A resource list containing comicsID in this series.
    var comicsID: Set<String>?

    /// A resource list containing comics in this series.
    let comics: [Comic]?

    mutating func removeID(_ itemID: String) {
        if itemID.starts(with: String.getType(from: Character.self)) {
            let id = itemID.dropFirst("\(String.getType(from: Character.self))#".count)
            charactersID?.remove(String(id))
        } else if itemID.starts(with: String.getType(from: Comic.self)) {
            let id = itemID.dropFirst("\(String.getType(from: Comic.self))#".count)
            comicsID?.remove(String(id))
        }
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
        case charactersID
        case characters
        case comicsID
        case comics
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        popularity = try values.decode(Int.self, forKey: .popularity)
        title = try values.decode(String.self, forKey: .title)
        dateAdded = Date()
        dateLastUpdated = Date()
        thumbnail = try? values.decode(String.self, forKey: .thumbnail)
        description = try? values.decode(String.self, forKey: .description)
        startYear = try? values.decode(Int.self, forKey: .startYear)
        endYear = try? values.decode(Int.self, forKey: .endYear)
        aliases = try? values.decode([String].self, forKey: .aliases)
        nextIdentifier = try? values.decode(String.self, forKey: .nextIdentifier)
        charactersID = try? values.decode(Set<String>.self, forKey: .charactersID)
        characters = try? values.decode([Character].self, forKey: .characters)
        comicsID = try? values.decode(Set<String>.self, forKey: .comicsID)
        comics = try? values.decode([Comic].self, forKey: .comics)
    }
    
}
