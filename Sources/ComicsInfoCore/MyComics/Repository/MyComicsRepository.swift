//
//  MyComicsRepository.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import Foundation
import NIO

public final class MyComicsRepository {

    private let dbWrapper: MyComicsDBWrapper

    init(dbWrapper: MyComicsDBWrapper) {
        self.dbWrapper = dbWrapper
    }
    
    func create(
        _ myComic: MyComic,
        table: String
    ) -> EventLoopFuture<MyComic> {
        dbWrapper.create(myComic, table: table)
    }

    func getMyComics(
        seriesID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<[MyComic]> {
        dbWrapper.getMyComics(seriesID: seriesID, userID: userID, table: table)
    }
    
    func getMyComic(
        withID myComicID: String,
        seriesID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<MyComic> {
        dbWrapper.getMyComic(withID: myComicID, seriesID: seriesID, userID: userID, table: table)
    }

    func update(
        _ myComic: MyComic,
        table: String
    ) -> EventLoopFuture<MyComic> {
        dbWrapper.update(myComic, table: table)
    }

    func delete(
        withID myComicID: String,
        seriesID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<MyComic> {
        dbWrapper.delete(withID: myComicID, seriesID: seriesID, userID: userID, table: table)
    }

}
