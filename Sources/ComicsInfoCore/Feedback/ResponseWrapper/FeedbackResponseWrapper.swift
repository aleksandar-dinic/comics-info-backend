//
//  FeedbackResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Feedback
import Foundation
import NIO

public struct FeedbackResponseWrapper: ErrorResponseWrapper {

    private let useCase: FeedbackUseCase

    public init(useCase: FeedbackUseCase) {
        self.useCase = useCase
    }

    public func handleCreate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.submit { response }
        }

        let table = String.tableName(for: environment)
        do {
            let item = try JSONDecoder().decode(Domain.Feedback.self, from: data)
            return useCase.create(Feedback(from: item, headers: request.headers), in: table)
                .map { Response(with: Domain.Feedback(from: $0), statusCode: .created) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseMessage(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.submit { response }
        }
    }

}
