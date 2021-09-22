//
//  FeedbackUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct FeedbackUseCaseFactory: FeedbackRepositoryBuilder {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool

    public init(on eventLoop: EventLoop, isLocalServer: Bool) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
    }

    public func makeUseCase() -> FeedbackUseCase {
        FeedbackUseCase(
            feedbackRepository: makeRepository(),
            emailService: makeEmailService()
        )
    }

}
