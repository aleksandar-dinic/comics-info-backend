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

    public let repositoryAPIService: RepositoryAPIService
    public let decoderService: DecoderService

    public init(
        repositoryAPIService: RepositoryAPIService,
        decoderService: DecoderService = DecoderProvider()
    ) {
        self.repositoryAPIService = repositoryAPIService
        self.decoderService = decoderService
    }

    // MARK: - Get item

    public func getItem(withID itemID: String, from table: String) -> EventLoopFuture<Character> {
        CharacterGetAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).get(withID: itemID, from: table)
    }

    public func getAllItems(from table: String) -> EventLoopFuture<[Character]> {
        CharacterGetAllAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAll(from: table)
    }

    // MARK: - Get metadata

    public func getMetadata(id: String, from table: String) -> EventLoopFuture<Character> {
        repositoryAPIService.getMetadata(withID: mapItemID(id), from: table)
            .flatMapThrowing { Character(from: try decoderService.decode(from: $0)) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Character.self) }
    }

    private func mapItemID(_ id: String) -> String {
        "\(String.getType(from: Item.self))#\(id)"
    }

    public func getAllMetadata(ids: Set<String>, from table: String) -> EventLoopFuture<[Character]> {
        CharacterGetAllMetadataAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAllMetadata(ids: ids, from: table)
    }

}
