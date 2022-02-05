//
//  MyComic.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import struct Domain.ComicSummary
import Foundation

struct MyComic: Codable {
    
    let userID: String
    let comicID: String
    let comicInSeriesID: String
    let popularity: Int
    let title: String
    let thumbnail: String?
    let description: String?
    let number: String?
    let published: Date?
    
    let itemID: String
    private let itemType: String
    private let sortValue: String
    private let dateAdded: Date
    private let dateLastUpdated: Date
    
}

extension MyComic {
    
    init(userID: String, seriesID: String, comicSummary: Domain.ComicSummary) {
        let now = Date()

        self.userID = userID
        self.comicInSeriesID = seriesID
        comicID = comicSummary.identifier
        popularity = comicSummary.popularity
        title = comicSummary.title
        thumbnail = comicSummary.thumbnail
        description = comicSummary.description
        number = comicSummary.number
        published = comicSummary.published
        itemID = "\(String.comicInfoID(for: MyComic.self, ID: comicID))#\(String.comicInfoID(for: Series.self, ID: seriesID))"
        itemType = .getType(from: MyComic.self)
        sortValue = "Popularity=\(abs(popularity-100))#Title=\(title)"
        dateAdded = now
        dateLastUpdated = now
    }
    
}
