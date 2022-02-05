//
//  MyComicsDBWrapper.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import Foundation
import NIO

struct MyComicsDBWrapper {
    
    var dbService: MyComicsDBService
    
    func create(
        _ myComic: MyComic,
        table: String
    ) -> EventLoopFuture<MyComic> {
        dbService.create(myComic, table: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: MyComic.self)
            }
    }

    func getMyComics(
        seriesID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<[MyComic]> {
        dbService.getMyComics(seriesID: seriesID, userID: userID, table: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: MyComic.self)
            }
    }
    
    func getMyComic(
        withID myComicID: String,
        seriesID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<MyComic> {
        let coimcID = String.comicInfoID(for: MyComic.self, ID: myComicID)
        let seriesID = String.comicInfoID(for: Series.self, ID: seriesID)
        let itemID = "\(coimcID)#\(seriesID)"

        return dbService.getMyComic(withID: itemID, userID: userID, table: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: MyComic.self)
            }
    }

    func update(
        _ myComic: MyComic,
        table: String
    ) -> EventLoopFuture<MyComic> {
        dbService.update(myComic, table: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: MyComic.self)
            }
    }

    func delete(
        withID myComicID: String,
        seriesID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<MyComic> {
        let coimcID = String.comicInfoID(for: MyComic.self, ID: myComicID)
        let seriesID = String.comicInfoID(for: Series.self, ID: seriesID)
        let itemID = "\(coimcID)#\(seriesID)"
        
        return dbService.delete(withID: itemID, userID: userID, table: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: MyComic.self)
            }
    }
    
}
