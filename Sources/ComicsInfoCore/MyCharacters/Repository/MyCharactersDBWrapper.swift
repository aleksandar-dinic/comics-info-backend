//
//  MyCharactersDBWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 16/01/2022.
//

import Foundation
import NIO

struct MyCharactersDBWrapper {
    
    var dbService: MyCharactersDBService
    
    func create(
        _ myCharacter: MyCharacter,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        dbService.create(myCharacter, in: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: MyCharacter.self)
            }
    }

    func getMyCharacters(
        for userID: String,
        from table: String
    ) -> EventLoopFuture<[MyCharacter]> {
        dbService.getMyCharacters(for: userID, from: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: MyCharacter.self)
            }
    }
    
    func getMyCharacter(
        withID characterID: String,
        for userID: String,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        let id = String.comicInfoID(for: MyCharacter.self, ID: characterID)
        return dbService.getMyCharacter(withID: id, for: userID, in: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: MyCharacter.self)
            }
    }

    func update(
        _ myCharacter: MyCharacter,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        dbService.update(myCharacter, in: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: MyCharacter.self)
            }
    }

    func delete(
        withID characterID: String,
        for userID: String,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        let id = String.comicInfoID(for: MyCharacter.self, ID: characterID)
        return dbService.delete(withID: id, for: userID, in: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: MyCharacter.self)
            }
    }
    
}
