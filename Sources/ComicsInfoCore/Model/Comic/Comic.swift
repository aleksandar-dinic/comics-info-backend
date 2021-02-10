//
//  Comic.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Comic: SummaryMapper {

    /// The unique ID of the comic resource.
    public let id: String

    /// The value of comic popularity.
    public private(set) var popularity: Int

    /// The canonical title of the comic.
    private(set) var title: String
    
    /// Date the comic was added to Comic Info.
    let dateAdded: Date
    
    /// Date the comic was last updated on Comic Info.
    private(set) var dateLastUpdated: Date

    /// The representative image for this comics.
    public private(set) var thumbnail: String?

    /// The preferred description of the comic.
    public private(set) var description: String?

    /// The number of the comic in the series.
    private(set) var number: String?
    
    /// List of aliases the comic is known by.
    private(set) var aliases: [String]?

    /// If the comic is a variant (e.g. an alternate cover, second printing, or director’s cut),
    /// a text description of the variant.
    private(set) var variantDescription: String?

    /// The publication format of the comic e.g. comic, hardcover, trade paperback.
    private(set) var format: String?

    /// The Int of story pages in the comic.
    private(set) var pageCount: Int?

    /// A list of variant comics ID for this comic (includes the "original" comic if the current
    /// comic is a variant).
    private(set) var variantsIdentifier: [String]?

    /// A list of collections ID which include this comic (will generally be nil if the comic's
    /// format is a collection).
    private(set) var collectionsIdentifier: [String]?

    /// A list of comics ID collected in this comic (will generally be nil for periodical formats
    /// such as "comic" or "magazine").
    private(set) var collectedIdentifiers: [String]?

    /// A list of promotional images associated with this comic.
    private(set) var images: [String]?

    /// The date of publication for this comic.
    private(set) var published: Date?

    /// A resource list containing charactersID which appear in this comic.
    var charactersID: Set<String>?

    /// A resource list containing the characters which appear in this comic.
    var characters: [CharacterSummary]?
    var comicSummaryForCharacters: [ComicSummary]?

    /// A resource list of seriesID in which this comic appears.
    var seriesID: Set<String>?

    /// A resource list containing the series in which this comic appears.
    var series: [SeriesSummary]?
    var comicSummaryForSeries: [ComicSummary]?
    
    public let itemID: String
    public let summaryID: String
    public let itemName: String
    
    public var name: String {
        title
    }
    
}

extension Comic {
    
    public mutating func update(with newItem: Comic) {
        popularity = newItem.popularity
        title = newItem.title
        dateLastUpdated = Date()
        
        if let thumbnail = newItem.thumbnail {
            self.thumbnail = thumbnail
        }
        if let description = newItem.description {
            self.description = description
        }
        if let number = newItem.number {
            self.number = number
        }
        
        aliases = update(aliases, with: newItem.aliases)
        
        if let variantDescription = newItem.variantDescription {
            self.variantDescription = variantDescription
        }
        if let format = newItem.format {
            self.format = format
        }
        if let pageCount = newItem.pageCount {
            self.pageCount = pageCount
        }

        variantsIdentifier = update(variantsIdentifier, with: newItem.variantsIdentifier)
        collectionsIdentifier = update(collectionsIdentifier, with: newItem.collectionsIdentifier)
        collectedIdentifiers = update(collectedIdentifiers, with: newItem.collectedIdentifiers)
        images = update(images, with: newItem.images)

        if let published = newItem.published {
            self.published = published
        }

        charactersID = newItem.charactersID
        characters = newItem.characters
        comicSummaryForCharacters = newItem.comicSummaryForCharacters
        seriesID = newItem.seriesID
        series = newItem.series
        comicSummaryForSeries = newItem.comicSummaryForSeries
    }
    
}

extension Comic {
    
    enum CodingKeys: String, CodingKey {
        case id
        case popularity
        case title
        case dateAdded
        case dateLastUpdated
        case thumbnail
        case description
        case number
        case aliases
        case variantDescription
        case format
        case pageCount
        case variantsIdentifier
        case collectionsIdentifier
        case collectedIdentifiers
        case images
        case published
        case itemID
        case summaryID
        case itemName
    }
    
}
