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
    public var id: String {
        itemID.getIDFromComicInfoID(for: Series.self)
    }

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
    private(set) var charactersID: Set<String>?

    /// A resource list containing characters which appear in comics in this series.
    var characters: [CharacterSummary]?

    /// A resource list containing comicsID in this series.
    private(set) var comicsID: Set<String>?

    /// A resource list containing comics in this series.
    var comics: [ComicSummary]?
    
    public let itemID: String
    public let itemType: String
    public private(set) var sortValue: String
    
    public var name: String {
        title
    }
    
    init(
        id: String,
        popularity: Int,
        title: String,
        thumbnail: String?,
        description: String?,
        startYear: Int?,
        endYear: Int?,
        aliases: [String]?,
        nextIdentifier: String?,
        charactersID: Set<String>?,
        comicsID: Set<String>?
    ) {
        let now = Date()
        
        self.popularity = popularity
        self.title = title
        dateAdded = now
        dateLastUpdated = now
        self.thumbnail = thumbnail
        self.description = description
        self.startYear = startYear
        self.endYear = endYear
        self.aliases = aliases
        self.nextIdentifier = nextIdentifier
        self.charactersID = charactersID
        self.comicsID = comicsID
        itemID = .comicInfoID(for: Series.self, ID: id)
        itemType = .getType(from: Series.self)
        sortValue = "Popularity=\(abs(popularity-100))#Title=\(title)"
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
        comicsID = newItem.comicsID
        comics = newItem.comics
        sortValue = "Popularity=\(abs(popularity-100))#Title=\(title)"
    }
    
}

extension Series {
    
    enum CodingKeys: String, CodingKey {
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
        case itemType
        case sortValue
    }
    
}
