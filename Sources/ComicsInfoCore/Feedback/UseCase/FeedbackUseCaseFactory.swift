//
//  FeedbackUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoCognitoAuthenticationKit
import NIO

public struct FeedbackUseCaseFactory: FeedbackRepositoryBuilder {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool
    public let userPoolID: String
    public let clientID: String
    public let clientSecret: String?

    public init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        userPoolID: String = .cognitoUserPoolID,
        clientID: String = .cognitoClientID,
        clientSecret: String? = .cognitoClientSecret
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.userPoolID = userPoolID
        self.clientID = clientID
        self.clientSecret = clientSecret
    }

    public func makeUseCase() -> FeedbackUseCase {
        FeedbackUseCase(
            feedbackRepository: makeRepository(),
            emailService: makeEmailService(),
            authService: makeAuthService()
        )
    }
    
    private func makeAuthService() -> AuthService {
        CognitoAuthenticatable(
            eventLoop: eventLoop,
            userPoolId: userPoolID,
            clientId: clientID,
            clientSecret: clientSecret,
            adminClient: true
        )
    }

}
