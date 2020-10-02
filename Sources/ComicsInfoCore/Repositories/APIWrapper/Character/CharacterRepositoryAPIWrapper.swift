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

    // MARK: - Create item

    public func create(_ item: Character) -> EventLoopFuture<Void> {
        let item = encoderService.encode(item, table: .characterTableName)
        return repositoryAPIService.create(item)
    }

    // MARK: - Get item

    public func getItem(withID itemID: String) -> EventLoopFuture<Character> {
        CharacterGetItemAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getItem(withID: itemID)
    }

    public func getAllItems() -> EventLoopFuture<[Character]> {
        CharacterGetAllAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAllCharacters()
    }

    // MARK: - Get metadata

    public func getMetadata(id: String) -> EventLoopFuture<Character> {
        return repositoryAPIService.getMetadata(withID: id).flatMapThrowing {
            Character(from: try decoderService.decode(from: $0))
        }
    }

    public func getAllMetadata(ids: Set<String>) -> EventLoopFuture<[Character]> {
        let ids = Set(ids.map { "\(String.characterType)#\($0)" })
        return repositoryAPIService.getAllMetadata(withIDs: ids).flatMapThrowing { items in
            var characters = [Character]()
            for item in items {
                guard let character: CharacterDatabase = try? decoderService.decode(from: item) else { continue }
                characters.append(Character(from: character))
            }

            guard !characters.isEmpty else { throw APIError.itemsNotFound(withIDs: ids, itemType: Series.self) }

            return characters
        }
    }

//    guard let items = items else { throw APIError.itemsNotFound(withIDs: ids, itemType: Character.self) }

}
