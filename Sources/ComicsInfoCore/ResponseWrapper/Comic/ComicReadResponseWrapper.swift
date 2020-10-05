//
//  ComicReadResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import Foundation
import NIO

public struct ComicReadResponseWrapper<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable>: ReadResponseWrapper where APIWrapper.Item == Comic, CacheProvider.Item == Comic {

    private let comicUseCase: ComicUseCase<APIWrapper, CacheProvider>

    public init(comicUseCase: ComicUseCase<APIWrapper, CacheProvider>) {
        self.comicUseCase = comicUseCase
    }

    public func handleRead(
        on eventLoop: EventLoop,
        request: Request
    ) -> EventLoopFuture<Response> {
        guard let id = request.pathParameters?["id"] else {
            let response = Response(statusCode: .notFound)
            return eventLoop.makeSucceededFuture(response)
        }

        return comicUseCase.getItem(withID: id, fromDataSource: .memory)
            .map { Response(with: Domain.Comic(from: $0), statusCode: .ok) }
            .flatMapError { self.catch($0, on: eventLoop) }
    }

}
