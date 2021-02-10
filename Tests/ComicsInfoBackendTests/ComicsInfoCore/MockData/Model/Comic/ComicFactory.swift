//
//  ComicFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 12/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum ComicFactory {
    
    static var requestBody: String {
        "{ \"identifier\": \"1\", \"title\": \"Comic Title\", \"popularity\": 0 }"
    }
    
    static func makeDatabaseItems() -> [String: Data] {
        let comic = make()
        return [comic.itemID: try! JSONEncoder().encode(comic)]
    }
    
    static func makeDatabaseItemsList() -> [String: Data] {
        var items = [String: Data]()
        for comic in makeList {
            items[comic.itemID] = try! JSONEncoder().encode(comic)
        }
        return items
    }

    static func make(ID: String = "1", popularity: Int = 0) -> Comic {
        make(
            id: ID,
            popularity: popularity,
            title: "Comic Title \(ID)",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "Comic Thumbnail \(ID)",
            description: "Comic Description \(ID)",
            number: "1",
            aliases: ["Comic Aliases \(ID)"],
            variantDescription: "Comic VariantDescription \(ID)",
            format: "Comic Format \(ID)",
            pageCount: 1,
            variantsIdentifier: ["Comic VariantsIdentifier \(ID)"],
            collectionsIdentifier: ["Comic CollectionsIdentifier \(ID)"],
            collectedIdentifiers: ["Comic collectedIdentifiers \(ID)"],
            images: ["Comic Images \(ID)"],
            published: Date(),
            charactersID: nil,
            characters: nil,
            seriesID: nil,
            series: nil
        )
    }
    
    static func make(
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
        characters: [CharacterSummary]? = nil,
        seriesID: Set<String>? = nil,
        series: [SeriesSummary]? = nil
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
            series: series,
            itemID: "Comic#\(id)",
            summaryID: "Comic#\(id)",
            itemName: "Comic"
        )
    }

    static var makeList: [Comic] {
        [
            make(ID: "2", popularity: 2),
            make(ID: "3", popularity: 3),
            make(ID: "4", popularity: 4)
        ]
    }

    static var items: [String: Any] {
        [
            "itemID": "Comic#1",
            "summaryID": "Comic#1",
            "itemName": "Comic",
            "summaryName": "Comic",
            "popularity": 0,
            "title": "Comic Title",
            "dateAdded": "14 January 2021 23:27:03",
            "dateLastUpdated": "14 January 2021 23:27:03",
            "thumbnail": "Comic Thumbnail",
            "description": "Comic Description"
        ]
    }

}
