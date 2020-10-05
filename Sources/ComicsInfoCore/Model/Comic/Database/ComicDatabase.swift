//
//  ComicDatabase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct ComicDatabase: Identifiable {

    var id: String {
        String(summaryID.dropFirst("\(String.getType(from: Comic.self))#".count))
    }

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let title: String
    let description: String?
    let thumbnail: String?
    let issueNumber: String?
    let variantDescription: String?
    let format: String?
    let pageCount: Int?
    let variantsIdentifier: [String]?
    let collectionsIdentifier: [String]?
    let collectedIssuesIdentifier: [String]?
    let images: [String]?
    let published: Date?
    var charactersSummary: [CharacterSummary]?
    var seriesSummary: [SeriesSummary]?

    func getCharactersID() -> Set<String>? {
        guard let charactersSummary = charactersSummary else { return nil }

        return Set(charactersSummary.compactMap { $0.id })
    }

    func getSeriesID() -> Set<String>? {
        guard let seriesSummary = seriesSummary else { return nil }

        return Set(seriesSummary.compactMap { $0.id })
    }

}

extension ComicDatabase {

    init(comic: Comic) {
        itemID = "\(String.getType(from: Comic.self))#\(comic.id)"
        summaryID = "\(String.getType(from: Comic.self))#\(comic.id)"
        itemName = .getType(from: Comic.self)
        popularity = comic.popularity
        title = comic.title
        description = comic.description
        thumbnail = comic.thumbnail
        issueNumber = comic.issueNumber
        variantDescription = comic.variantDescription
        format = comic.format
        pageCount = comic.pageCount
        variantsIdentifier = comic.variantsIdentifier
        collectionsIdentifier = comic.collectionsIdentifier
        collectedIssuesIdentifier = comic.collectedIssuesIdentifier
        images = comic.images
        published = comic.published
        charactersSummary = comic.characters?.compactMap {
            CharacterSummary($0, id: comic.id, itemName: .getType(from: Comic.self))
        }
        seriesSummary = comic.series?.compactMap {
            SeriesSummary($0, id: comic.id, itemName: .getType(from: Comic.self))
        }
    }

}
