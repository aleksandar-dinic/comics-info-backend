//
//  CognitoAuthenticatable+AuthService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 20/01/2022.
//

import Foundation
import SotoCognitoAuthenticationKit

extension CognitoAuthenticatable: AuthService {
    
    public func authenticate(token: String, on eventLoop: EventLoop) -> EventLoopFuture<User> {
        print("Authenticate token: \(token)")
        return authenticate(accessToken: token, on: eventLoop)
            .map { User(identifier: $0.subject, username: $0.username) }
            .flatMapErrorThrowing {
                print("Authenticate ERROR: \($0)")
                throw $0
            }
    }
    
}

