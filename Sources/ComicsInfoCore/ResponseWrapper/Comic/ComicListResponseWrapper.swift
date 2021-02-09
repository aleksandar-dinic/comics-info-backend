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

public struct ComicListResponseWrapper<DBService: ItemGetDBService, CacheProvider: Cacheable>: ListResponseWrapper where CacheProvider.Item == Comic {

    private let comicUseCase: ComicUseCase<DBService, CacheProvider>

    public init(comicUseCase: ComicUseCase<DBService, CacheProvider>) {
        self.comicUseCase = comicUseCase
    }

    public func handleList(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        let table = String.tableName(for: environment)
        let fields = getFields(from: request.queryParameters)
        
        return comicUseCase.getAllItems(on: eventLoop, fields: fields, from: table)
            .map { Response(with: $0.map { Domain.Comic(from: $0) }, statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0) }
    }

}
