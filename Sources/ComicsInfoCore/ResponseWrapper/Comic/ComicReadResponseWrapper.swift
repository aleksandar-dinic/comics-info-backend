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

public struct ComicReadResponseWrapper<DBService: ItemGetDBService, CacheProvider: Cacheable>: ReadResponseWrapper where CacheProvider.Item == Comic {

    private let comicUseCase: ComicUseCase<DBService, CacheProvider>

    public init(comicUseCase: ComicUseCase<DBService, CacheProvider>) {
        self.comicUseCase = comicUseCase
    }

    public func handleRead(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        guard let id = request.pathParameters?["id"] else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }
        
        let fields = getFields(from: request.queryParameters)

        let table = String.tableName(for: environment)
        return comicUseCase.getItem(on: eventLoop, withID: id, fields: fields, from: table)
            .map { Response(with: Domain.Comic(from: $0), statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0) }
    }
    
}
