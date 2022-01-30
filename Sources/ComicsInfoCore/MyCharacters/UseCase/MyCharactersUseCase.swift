//
//  MyCharactersUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/01/2022.
//

import struct Domain.MyCharacter
import Foundation
import NIO

public final class MyCharactersUseCase {
    
    public let repository: MyCharactersRepository
    public let authService: AuthService
    
    init(
        repository: MyCharactersRepository,
        authService: AuthService
    ) {
        self.repository = repository
        self.authService = authService
    }
    
    func createMyCharacter(
        with request: CreateMyCharacterRequest
    ) -> EventLoopFuture<MyCharacter> {
        authService.authenticate(token: request.token, on: request.eventLoop)
            .flatMapThrowing { user -> MyCharacter in
                let item = try JSONDecoder().decode(Domain.MyCharacter.self, from: request.data)
                return MyCharacter(for: user.id, myCharacter: item)
            }
            .flatMap { [weak self] myCharacter in
                guard let self = self else {
                    return request.eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }
                return self.repository.create(myCharacter, in: request.table)
            }
    }
    
    func getMyCharacters(
        token: String,
        from table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[MyCharacter]> {
        authService.authenticate(token: token, on: eventLoop)
            .flatMap { [weak self] user in
                guard let self = self else {
                    return eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }
                return self.repository.getMyCharacters(for: user.id, from: table)
            }
    }
    
    func getMyCharacter(
        withID characterID: String,
        token: String,
        in table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<MyCharacter> {
        authService.authenticate(token: token, on: eventLoop)
            .flatMap { [weak self] user in
                guard let self = self else {
                    return eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }
                return self.repository.getMyCharacter(withID: characterID, for: user.id, in: table)
            }
    }

    func updateMyCharacter(
        with request: UpdateMyCharacterRequest
    ) -> EventLoopFuture<MyCharacter> {
        authService.authenticate(token: request.token, on: request.eventLoop)
            .flatMapThrowing { user -> MyCharacter in
                let item = try JSONDecoder().decode(Domain.MyCharacter.self, from: request.data)
                guard item.identifier == request.id else {
                    throw ComicInfoError.cannotUpdateItemID(type: MyCharacter.self)
                }
                return MyCharacter(for: user.id, myCharacter: item)
            }
            .flatMap { [weak self] myCharacter in
                guard let self = self else {
                    return request.eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }
                return self.repository.update(myCharacter, in: request.table)
            }
    }

    func delete(
        withID characterID: String,
        token: String,
        in table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<MyCharacter> {
        authService.authenticate(token: token, on: eventLoop)
            .flatMap { [weak self] user in
                guard let self = self else {
                    return eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }
                return self.repository.delete(withID: characterID, for: user.id, in: table)
            }
    }

}
