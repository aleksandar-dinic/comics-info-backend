//
//  ComicSummaryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.ComicSummary
import Foundation

enum ComicSummaryMock {

    static func makeComicSummary(
        itemID: String = "comic#1",
        summaryID: String = "comic#1",
        itemName: String = "comic",
        summaryName: String = "comic",
        popularity: Int = 0,
        title: String = "ComicSummary 1 Title",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil
    ) -> ComicSummary {
        ComicSummary(
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            summaryName: summaryName,
            popularity: popularity,
            title: title,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            thumbnail: thumbnail,
            description: description
        )
    }

    static var comicSummary: ComicSummary {
        ComicSummary(
            itemID: "comic#1",
            summaryID: "comic#1",
            itemName: "comic",
            summaryName: "comic",
            popularity: 0,
            title: "ComicSummary 1 Title",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "ComicSummary 1 Thumbnail",
            description: "ComicSummary 1 Description"
        )
    }

}
