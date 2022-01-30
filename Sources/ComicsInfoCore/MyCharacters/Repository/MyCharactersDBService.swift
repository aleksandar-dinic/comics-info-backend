//
//  MyCharactersDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 16/01/2022.
//

import class NIO.EventLoopFuture
import Foundation

protocol MyCharactersDBService {
    
    func create(
        _ myCharacter: MyCharacter,
        in table: String
    ) -> EventLoopFuture<MyCharacter>

    func getMyCharacters(
        for userID: String,
        from table: String
    ) -> EventLoopFuture<[MyCharacter]>
    
    func getMyCharacter(
        withID myCharacterID: String,
        for userID: String,
        in table: String
    ) -> EventLoopFuture<MyCharacter>

    func update(
        _ myCharacter: MyCharacter,
        in table: String
    ) -> EventLoopFuture<MyCharacter>

    func delete(
        withID myCharacterID: String,
        for userID: String,
        in table: String
    ) -> EventLoopFuture<MyCharacter>

}
