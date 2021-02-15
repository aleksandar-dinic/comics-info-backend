//
//  SeriesCreateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import struct Logging.Logger
import Foundation
import NIO

public struct SeriesCreateResponseWrapper: CreateResponseWrapper {

    private let useCase: SeriesCreateUseCase

    public init(useCase: SeriesCreateUseCase) {
        self.useCase = useCase
    }

    public func handleCreate(
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
            let item = try JSONDecoder().decode(Domain.Series.self, from: data)
            let criteria = CreateItemCriteria(item: Series(from: item), on: eventLoop, in: table, log: logger)
            return useCase.create(with: criteria)
                .map { Response(with: ResponseStatus("\(type(of: item.self)) created"), statusCode: .created) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseStatus(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.submit { response }
        }
    }

}
