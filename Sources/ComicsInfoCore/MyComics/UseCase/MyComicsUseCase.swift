//
//  MyComicsUseCase.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import struct Domain.ComicSummary
import Foundation
import NIO

public final class MyComicsUseCase {
    
    public let repository: MyComicsRepository
    public let authService: AuthService
    
    init(
        repository: MyComicsRepository,
        authService: AuthService
    ) {
        self.repository = repository
        self.authService = authService
    }
    
    func createMyComic(
        with request: CreateMyComicRequest
    ) -> EventLoopFuture<MyComic> {
        authService.authenticate(token: request.token, on: request.eventLoop)
            .flatMapThrowing { user -> MyComic in
                let item = try JSONDecoder().decode(Domain.ComicSummary.self, from: request.data)
                return MyComic(userID: user.id, seriesID: request.seriesID, comicSummary: item)
            }
            .flatMap { [weak self] myComic in
                guard let self = self else {
                    return request.eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }
                return self.repository.create(myComic, table: request.table)
            }
    }
    
    func getMyComics(
        with request: ListMyComicRequest
    ) -> EventLoopFuture<[MyComic]> {
        authService.authenticate(token: request.token, on: request.eventLoop)
            .flatMap { [weak self] user in
                guard let self = self else {
                    return request.eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }
                return self.repository.getMyComics(seriesID: request.seriesID, userID: user.id, table: request.table)
            }
    }
    
    func getMyComic(
        with request: ReadMyComicRequest
    ) -> EventLoopFuture<MyComic> {
        authService.authenticate(token: request.token, on: request.eventLoop)
            .flatMap { [weak self] user in
                guard let self = self else {
                    return request.eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }
                return self.repository.getMyComic(withID: request.comicID, seriesID: request.seriesID, userID: user.id, table: request.table)
            }
    }

    func updateMyComic(
        with request: UpdateMyComicRequest
    ) -> EventLoopFuture<MyComic> {
        authService.authenticate(token: request.token, on: request.eventLoop)
            .flatMapThrowing { user -> MyComic in
                let item = try JSONDecoder().decode(Domain.ComicSummary.self, from: request.data)
                guard item.identifier == request.id else {
                    throw ComicInfoError.cannotUpdateItemID(type: MyComic.self)
                }
                return MyComic(userID: user.id, seriesID: request.seriesID, comicSummary: item)
            }
            .flatMap { [weak self] myComic in
                guard let self = self else {
                    return request.eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }
                return self.repository.update(myComic, table: request.table)
            }
    }

    func delete(
        with request: DeleteMyComicRequest
    ) -> EventLoopFuture<MyComic> {
        authService.authenticate(token: request.token, on: request.eventLoop)
            .flatMap { [weak self] user in
                guard let self = self else {
                    return request.eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }
                return self.repository.delete(withID: request.comicID, seriesID: request.seriesID, userID: user.id, table: request.table)
            }
    }

}
