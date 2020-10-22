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
        tableName: String = "comic",
        itemID: String = "comic#1",
        summaryID: String = "comic#1",
        itemName: String = "comic",
        popularity: Int = 0,
        title: String = "ComicSummary 1 Title",
        thumbnail: String? = nil,
        description: String? = nil
    ) -> ComicSummary {
        ComicSummary(
            tableName: tableName,
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            popularity: popularity,
            title: title,
            thumbnail: thumbnail,
            description: description
        )
    }

    static var comicSummary: ComicSummary {
        ComicSummary(
            tableName: "comic",
            itemID: "comic#1",
            summaryID: "comic#1",
            itemName: "comic",
            popularity: 0,
            title: "ComicSummary 1 Title",
            thumbnail: "ComicSummary 1 Thumbnail",
            description: "ComicSummary 1 Description"
        )
    }

}
