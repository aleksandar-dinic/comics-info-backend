//
//  ComicReadResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import struct Logging.Logger
import Foundation
import NIO

public struct ComicReadResponseWrapper: ReadResponseWrapper {

    private let comicUseCase: ComicUseCase

    public init(comicUseCase: ComicUseCase) {
        self.comicUseCase = comicUseCase
    }

    public func handleRead(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response> {
        guard let id = request.pathParameters?["id"] else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.submit { response }
        }
        
        let fields = getFields(from: request.queryParameters)

        let table = String.tableName(for: environment)
        return comicUseCase.getItem(on: eventLoop, withID: id, fields: fields, from: table, logger: logger)
            .map { Response(with: Domain.Comic(from: $0), statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0) }
    }
    
}
