//
//  ComicUpdateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import struct Logging.Logger
import Foundation
import NIO

public struct ComicUpdateResponseWrapper: UpdateResponseWrapper {

    private let comicUseCase: ComicUpdateUseCase

    public init(comicUseCase: ComicUpdateUseCase) {
        self.comicUseCase = comicUseCase
    }

    public func handleUpdate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.submit { response }
        }

        let table = String.tableName(for: environment)
        do {
            let item = try JSONDecoder().decode(Domain.Comic.self, from: data)
            let comic = Comic(from: item)
            let criteria = UpdateItemCriteria(
                item: comic,
                oldSortValue: comic.sortValue,
                on: eventLoop,
                in: table,
                log: logger
            )
            return comicUseCase.update(with: criteria)
                .map { Response(with: Domain.Comic(from: $0), statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }

}
