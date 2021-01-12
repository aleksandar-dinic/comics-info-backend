//
//  ComicRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct ComicRepositoryAPIWrapper: RepositoryAPIWrapper {

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

    public func getItem(withID itemID: String, from table: String) -> EventLoopFuture<Comic> {
        ComicGetAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).get(withID: itemID, from: table)
    }

    public func getAllItems(from table: String) -> EventLoopFuture<[Comic]> {
        ComicGetAllAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAll(from: table)
    }

    // MARK: - Get metadata

    public func getMetadata(id: String, from table: String) -> EventLoopFuture<Comic> {
        repositoryAPIService.getMetadata(withID: mapItemID(id), from: table)
            .flatMapThrowing { Comic(from: try decoderService.decode(from: $0)) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Comic.self) }
    }

    private func mapItemID(_ id: String) -> String {
        "\(String.getType(from: Item.self))#\(id)"
    }

    public func getAllMetadata(ids: Set<String>, from table: String) -> EventLoopFuture<[Comic]> {
        ComicGetAllMetadataAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAllMetadata(ids: ids, from: table)
    }

}
