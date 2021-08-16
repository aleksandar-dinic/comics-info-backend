//
//  GetComics.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.ComicSummary
@testable import struct ComicsInfoCore.Comic
import Foundation

enum ComicSummaryFactory {
    
    static func make(ID: String = "1", popularity: Int = 0) -> ComicSummary {
        make(
            ID: ID,
            link: ComicFactory.make(ID: "9"),
            popularity: 0,
            name: "ComicSummary \(ID) Name",
            thumbnail: "ComicSummary \(ID) Thumbnail",
            description: "ComicSummary \(ID) Description",
            number: "1"
        )
    }

    static func make(
        ID: String = "1",
        link: Comic = ComicFactory.make(ID: "9"),
        popularity: Int = 0,
        name: String = "ComicSummary 1 Name",
        thumbnail: String? = nil,
        description: String? = nil,
        number: String? = nil,
        published: Date? = Date()
    ) -> ComicSummary {
        ComicSummary(
            ID: ID,
            link: link,
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description,
            number: number,
            published: published
        )
    }
    
    static func comicList() -> [ComicSummary] {
        [
            make(ID: "2", popularity: 2),
            make(ID: "3", popularity: 3),
            make(ID: "4", popularity: 4)
        ]
    }

}
