//
//  CharacterRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct CharacterRepositoryAPIWrapper: RepositoryAPIWrapper {

    public let eventLoop: EventLoop
    public let repositoryAPIService: RepositoryAPIService
    public let decoderService: DecoderService
    public let encoderService: EncoderService

    public init(
        on eventLoop: EventLoop,
        repositoryAPIService: RepositoryAPIService,
        decoderService: DecoderService = DecoderProvider(),
        encoderService: EncoderService = EncoderProvider()
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIService = repositoryAPIService
        self.decoderService = decoderService
        self.encoderService = encoderService
    }

    public func create(_ item: Character) -> EventLoopFuture<Void> {
        let item = encoderService.encode(item)
        return repositoryAPIService.create(item)
    }

    public func getItem(withID itemID: String) -> EventLoopFuture<Character> {
        CharacterQueryAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getItem(withID: itemID)
    }

    public func getAllItems() -> EventLoopFuture<[Character]> {
        repositoryAPIService.getAllItems().flatMapThrowing {
            let charactersDatabase: [CharacterDatabase] = try decoderService.decodeAll(from: $0)
            return charactersDatabase.map { Character(from: $0) }
        }
    }

    public func getMetadata(id: String) -> EventLoopFuture<Character> {
        return repositoryAPIService.getMetadata(id: id).flatMapThrowing {
            return Character(from: try decoderService.decode(from: $0))
        }
    }

    public func getAllMetadata(ids: Set<String>) -> EventLoopFuture<[Character]> {
        let ids = Set(ids.map { "\(String.characterType)#\($0)" })
        return repositoryAPIService.getAllMetadata(ids: ids).flatMapThrowing {
            let charactersDatabase: [CharacterDatabase] = try decoderService.decodeAll(from: $0)
            return charactersDatabase.map { Character(from: $0) }
        }
    }

}
