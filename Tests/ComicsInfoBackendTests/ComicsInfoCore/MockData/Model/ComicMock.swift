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
        issueNumber: String? = nil,
        variantDescription: String? = nil,
        format: String? = nil,
        pageCount: Int? = nil,
        variantsIdentifier: [String]? = nil,
        collectionsIdentifier: [String]? = nil,
        collectedIssuesIdentifier: [String]? = nil,
        images: [String]? = nil,
        published: Date? = nil,
        charactersID: Set<String>? = nil,
        characters: [Character]? = nil,
        seriesID: Set<String>? = nil,
        series: [Series]? = nil
    ) -> Comic {
        Comic(
            id: id,
            popularity: popularity,
            title: title,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            thumbnail: thumbnail,
            description: description,
            issueNumber: issueNumber,
            variantDescription: variantDescription,
            format: format,
            pageCount: pageCount,
            variantsIdentifier: variantsIdentifier,
            collectionsIdentifier: collectionsIdentifier,
            collectedIssuesIdentifier: collectedIssuesIdentifier,
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
            issueNumber: "1",
            variantDescription: "Comic VariantDescription",
            format: "Comic Format",
            pageCount: 1,
            variantsIdentifier: ["Comic VariantsIdentifier"],
            collectionsIdentifier: ["Comic CollectionsIdentifier"],
            collectedIssuesIdentifier: ["Comic CollectedIssuesIdentifier"],
            images: ["Comic Images"],
            published: Date(),
            charactersID: ["1"],
            characters: CharacterMock.charactersList,
            seriesID: ["1"],
            series: SeriesMock.seriesList
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
                issueNumber: nil,
                variantDescription: nil,
                format: nil,
                pageCount: nil,
                variantsIdentifier: nil,
                collectionsIdentifier: nil,
                collectedIssuesIdentifier: nil,
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
                issueNumber: nil,
                variantDescription: nil,
                format: nil,
                pageCount: nil,
                variantsIdentifier: nil,
                collectionsIdentifier: nil,
                collectedIssuesIdentifier: nil,
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
                issueNumber: nil,
                variantDescription: nil,
                format: nil,
                pageCount: nil,
                variantsIdentifier: nil,
                collectionsIdentifier: nil,
                collectedIssuesIdentifier: nil,
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
            "popularity": 0,
            "title": "Comic Title",
            "dateAdded": "January 01, 2000",
            "dateLastUpdated": "January 01, 2000",
            "thumbnail": "Comic Thumbnail",
            "description": "Comic Description"
        ]
    }

}
