//
//  ComicListResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import Foundation
import NIO

public struct ComicListResponseWrapper<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable>: ListResponseWrapper where APIWrapper.Item == Comic, CacheProvider.Item == Comic {

    private let comicUseCase: ComicUseCase<APIWrapper, CacheProvider>

    public init(comicUseCase: ComicUseCase<APIWrapper, CacheProvider>) {
        self.comicUseCase = comicUseCase
    }

    public func handleList(on eventLoop: EventLoop) -> EventLoopFuture<Response> {
        comicUseCase.getAllItems(fromDataSource: .memory)
            .map { Response(with: $0.map { Domain.Comic(from: $0) }, statusCode: .ok) }
            .flatMapError { self.catch($0, on: eventLoop) }
    }

}
