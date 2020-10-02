//
//  SeriesRepositoryAPIWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 27/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct SeriesRepositoryAPIWrapper: RepositoryAPIWrapper {

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

    public func create(_ item: Series) -> EventLoopFuture<Void> {
        SeriesCreateAPIWrapper(
            on: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService
        ).create(item)
    }

    // FIXME: - Change getMetadata when implement getItem
    public func getItem(withID itemID: String) -> EventLoopFuture<Series> {
        repositoryAPIService.getMetadata(withID: itemID).flatMapThrowing {
            Series(from: try decoderService.decode(from: $0))
        }
    }

    public func getAllItems() -> EventLoopFuture<[Series]> {
        repositoryAPIService.getAll(.seriesType)
            .flatMapThrowing { items in
                var series = [Series]()
                for item in items {
                    guard let seriesDatabase: SeriesDatabase = try? decoderService.decode(from: item) else { continue }
                    series.append(Series(from: seriesDatabase))
                }

                guard !series.isEmpty else {
                    throw APIError.itemsNotFound(withIDs: nil, itemType: Series.self)
                }

                return series
            }.flatMapErrorThrowing { throw handleError($0) }
    }

    public func getMetadata(id: String) -> EventLoopFuture<Series> {
        repositoryAPIService.getMetadata(withID: id).flatMapThrowing {
            Series(from: try decoderService.decode(from: $0))
        }
    }

    public func getAllMetadata(ids: Set<String>) -> EventLoopFuture<[Series]> {
        repositoryAPIService.getAllMetadata(withIDs: ids).flatMapThrowing { items in
            var series = [Series]()
            for item in items {
                guard let seriesDatabase: SeriesDatabase = try? decoderService.decode(from: item) else { continue }
                series.append(Series(from: seriesDatabase))
            }

            guard !series.isEmpty else {
                throw APIError.itemsNotFound(withIDs: ids, itemType: Series.self)
            }

            return series
        }.flatMapErrorThrowing { throw handleError($0) }
    }

    private func handleError(_ error: Error) -> Error {
        guard let dbError = error as? DatabaseError else { return error }

        switch dbError {
        case .itemDoesNotHaveID:
            return APIError.requestError

        case let .itemAlreadyExists(withID: id):
            return APIError.itemAlreadyExists(withID: id, itemType: Series.self)

        case let .itemNotFound(withID: id):
            return APIError.itemNotFound(withID: id, itemType: Series.self)

        case let .itemsNotFound(withIDs: ids):
            return APIError.itemsNotFound(withIDs: ids, itemType: Series.self)
        }
    }

}
