//
//  ComicMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 12/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum ComicMock {

    static func makeComic(
        id: String = "1",
        popularity: Int = 0,
        title: String = "Comic Title",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil,
        number: String? = nil,
        aliases: [String]? = nil,
        variantDescription: String? = nil,
        format: String? = nil,
        pageCount: Int? = nil,
        variantsIdentifier: [String]? = nil,
        collectionsIdentifier: [String]? = nil,
        collectedIdentifiers: [String]? = nil,
        images: [String]? = nil,
        published: Date? = nil,
        charactersID: Set<String>? = nil,
        characters: [ItemSummary<Character>]? = nil,
        seriesID: Set<String>? = nil,
        series: [ItemSummary<Series>]? = nil
    ) -> Comic {
        Comic(
            id: id,
            popularity: popularity,
            title: title,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            thumbnail: thumbnail,
            description: description,
            number: number,
            aliases: aliases,
            variantDescription: variantDescription,
            format: format,
            pageCount: pageCount,
            variantsIdentifier: variantsIdentifier,
            collectionsIdentifier: collectionsIdentifier,
            collectedIdentifiers: collectedIdentifiers,
            images: images,
            published: published,
            charactersID: charactersID,
            characters: characters,
            seriesID: seriesID,
            series: series
        )
    }

    static var requestBody: String {
        "{ \"id\": \"1\", \"title\": \"Title\", \"popularity\": 0 }"
    }

    static var comic: Comic {
        Comic(
            id: "1",
            popularity: 0,
            title: "Comic Title",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "Comic Thumbnail",
            description: "Comic Description",
            number: "1",
            aliases: ["Comic Aliases"],
            variantDescription: "Comic VariantDescription",
            format: "Comic Format",
            pageCount: 1,
            variantsIdentifier: ["Comic VariantsIdentifier"],
            collectionsIdentifier: ["Comic CollectionsIdentifier"],
            collectedIdentifiers: ["Comic collectedIdentifiers"],
            images: ["Comic Images"],
            published: Date(),
            charactersID: ["1"],
            characters: CharacterSummaryMock.characterSummaryList,
            seriesID: ["1"],
            series: SeriesSummaryMock.seriesSummaryList
        )
    }

    static var comicList: [Comic] {
        [
            Comic(
                id: "2",
                popularity: 2,
                title: "Comic Title 2",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Comic Thumbnail 2",
                description: "Comic Description 2",
                number: nil,
                aliases: nil,
                variantDescription: nil,
                format: nil,
                pageCount: nil,
                variantsIdentifier: nil,
                collectionsIdentifier: nil,
                collectedIdentifiers: nil,
                images: nil,
                published: nil,
                charactersID: nil,
                characters: nil,
                seriesID: nil,
                series: nil
            ),
            Comic(
                id: "3",
                popularity: 3,
                title: "Comic Title 3",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Comic Thumbnail 3",
                description: "Comic Description 3",
                number: nil,
                aliases: nil,
                variantDescription: nil,
                format: nil,
                pageCount: nil,
                variantsIdentifier: nil,
                collectionsIdentifier: nil,
                collectedIdentifiers: nil,
                images: nil,
                published: nil,
                charactersID: nil,
                characters: nil,
                seriesID: nil,
                series: nil
            ),
            Comic(
                id: "4",
                popularity: 4,
                title: "Comic Title 4",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Comic Thumbnail 4",
                description: "Comic Description 4",
                number: nil,
                aliases: nil,
                variantDescription: nil,
                format: nil,
                pageCount: nil,
                variantsIdentifier: nil,
                collectionsIdentifier: nil,
                collectedIdentifiers: nil,
                images: nil,
                published: nil,
                charactersID: nil,
                characters: nil,
                seriesID: nil,
                series: nil
            )
        ]
    }

    static var items: [String: Any] {
        [
            "itemID": "comic#1",
            "summaryID": "comic#1",
            "itemName": "comic",
            "summaryName": "comic",
            "popularity": 0,
            "title": "Comic Title",
            "dateAdded": "14 January 2021 23:27:03",
            "dateLastUpdated": "14 January 2021 23:27:03",
            "thumbnail": "Comic Thumbnail",
            "description": "Comic Description"
        ]
    }

}
