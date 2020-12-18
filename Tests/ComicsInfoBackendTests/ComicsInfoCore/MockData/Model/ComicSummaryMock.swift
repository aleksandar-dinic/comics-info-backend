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
        popularity: Int = 0,
        title: String = "ComicSummary 1 Title",
        thumbnail: String? = nil,
        description: String? = nil
    ) -> ComicSummary {
        ComicSummary(
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
