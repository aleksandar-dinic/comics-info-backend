//
//  CreateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CreateResponseWrapper<UseCaseType: UseCase>: ErrorResponseWrapper {

    private let useCase: UseCaseType

    init(useCase: UseCaseType) {
        self.useCase = useCase
    }

    func handleCreate(
        on eventLoop: EventLoop,
        request: Request
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }

        do {
            let item = try JSONDecoder().decode(UseCaseType.Item.self, from: data)
            return useCase.create(item)
                .map { Response(with: ResponseStatus("\(String(describing: type(of: item))) created"), statusCode: .created) }
                .flatMapError { self.catch($0, on: eventLoop, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseStatus(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }
    }

}
