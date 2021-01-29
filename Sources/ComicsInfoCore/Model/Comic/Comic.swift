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
    public let popularity: Int

    /// The canonical title of the comic.
    let title: String
    
    /// Date the comic was added to Comic Info.
    let dateAdded: Date
    
    /// Date the comic was last updated on Comic Info.
    let dateLastUpdated: Date

    /// The representative image for this comics.
    public let thumbnail: String?

    /// The preferred description of the comic.
    public let description: String?

    /// The number of the comic in the series.
    let number: String?
    
    /// List of aliases the comic is known by.
    let aliases: [String]?

    /// If the comic is a variant (e.g. an alternate cover, second printing, or director’s cut),
    /// a text description of the variant.
    let variantDescription: String?

    /// The publication format of the comic e.g. comic, hardcover, trade paperback.
    let format: String?

    /// The Int of story pages in the comic.
    let pageCount: Int?

    /// A list of variant comics ID for this comic (includes the "original" comic if the current
    /// comic is a variant).
    let variantsIdentifier: [String]?

    /// A list of collections ID which include this comic (will generally be nil if the comic's
    /// format is a collection).
    let collectionsIdentifier: [String]?

    /// A list of comics ID collected in this comic (will generally be nil for periodical formats
    /// such as "comic" or "magazine").
    let collectedIdentifiers: [String]?

    /// A list of promotional images associated with this comic.
    let images: [String]?

    /// The date of publication for this comic.
    let published: Date?

    /// A resource list containing charactersID which appear in this comic.
    var charactersID: Set<String>?

    /// A resource list containing the characters which appear in this comic.
    var characters: [CharacterSummary<Comic>]?
    var comicSummaryForCharacters: [ComicSummary<Character>]?

    /// A resource list of seriesID in which this comic appears.
    var seriesID: Set<String>?

    /// A resource list containing the series in which this comic appears.
    var series: [SeriesSummary<Comic>]?
    var comicSummaryForSeries: [ComicSummary<Series>]?
    
    public let itemID: String
    public let summaryID: String
    public let itemName: String
    
    public var name: String {
        title
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
