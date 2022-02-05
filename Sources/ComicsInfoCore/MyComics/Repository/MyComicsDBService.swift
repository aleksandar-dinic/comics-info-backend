//
//  MyComicsDBService.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import class NIO.EventLoopFuture
import Foundation

protocol MyComicsDBService {
    
    func create(
        _ myComic: MyComic,
        table: String
    ) -> EventLoopFuture<MyComic>

    func getMyComics(
        seriesID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<[MyComic]>
    
    func getMyComic(
        withID itemID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<MyComic>

    func update(
        _ myComic: MyComic,
        table: String
    ) -> EventLoopFuture<MyComic>

    func delete(
        withID itemID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<MyComic>

}
