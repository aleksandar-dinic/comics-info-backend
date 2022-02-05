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
        do {
            let request = try CreateFeedbackRequest(
                request: request,
                environment: environment,
                eventLoop: eventLoop
            )
            
            return useCase.create(with: request)
                .map { Response(with: Domain.Feedback(from: $0), statusCode: .created) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }

}
