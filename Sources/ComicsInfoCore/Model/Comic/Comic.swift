//
//  Comic.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Comic: Codable, Identifiable {

    /// The unique ID of the comic resource.
    public let id: String

    /// The value of comic popularity.
    let popularity: Int

    /// The canonical title of the comic.
    let title: String

    /// The representative image for this comics.
    let thumbnail: String?

    /// The preferred description of the comic.
    let description: String?

    /// The number of the issue in the series.
    let issueNumber: String?

    /// If the issue is a variant (e.g. an alternate cover, second printing, or director’s cut),
    /// a text description of the variant.
    let variantDescription: String?

    /// The publication format of the comic e.g. comic, hardcover, trade paperback.
    let format: String?

    /// The Int of story pages in the comic.
    let pageCount: Int?

    /// A list of variant issues ID for this comic (includes the "original" issue if the current
    /// issue is a variant).
    let variantsIdentifier: [String]?

    /// A list of collections ID which include this comic (will generally be nil if the comic's
    /// format is a collection).
    let collectionsIdentifier: [String]?

    /// A list of issues ID collected in this comic (will generally be nil for periodical formats
    /// such as "comic" or "magazine").
    let collectedIssuesIdentifier: [String]?

    /// A list of promotional images associated with this comic.
    let images: [String]?

    /// The date of publication for this comic.
    let published: Date?

    /// A resource list containing charactersID which appear in this comic.
    let charactersID: Set<String>?

    /// A resource list containing the characters which appear in this comic.
    let characters: [Character]?

    /// A resource list of seriesID in which this comic appears.
    let seriesID: Set<String>?

    /// A resource list containing the series in which this comic appears.
    let series: [Series]?

}
