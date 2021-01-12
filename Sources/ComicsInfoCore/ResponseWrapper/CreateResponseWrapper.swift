//
//  CreateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CreateResponseWrapper<UseCaseType: CreateUseCase>: ErrorResponseWrapper {

    private let useCase: UseCaseType

    init(useCase: UseCaseType) {
        self.useCase = useCase
    }

    func handleCreate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }

        let table = String.tableName(for: environment)
        do {
            let item = try JSONDecoder().decode(UseCaseType.Item.self, from: data)
            return useCase.create(item, in: table)
                .map { Response(with: ResponseStatus("\(type(of: item.self)) created"), statusCode: .created) }
                .flatMapError { self.catch($0, on: eventLoop, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseStatus(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }
    }

}
