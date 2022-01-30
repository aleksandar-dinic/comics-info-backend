//
//  MyCharactersUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/01/2022.
//

import Foundation
import SotoCognitoAuthenticationKit
import NIO

public struct MyCharactersUseCaseFactory: MyCharactersRepositoryBuilder {

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

    public func makeUseCase() -> MyCharactersUseCase {
        MyCharactersUseCase(
            repository: makeRepository(),
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
