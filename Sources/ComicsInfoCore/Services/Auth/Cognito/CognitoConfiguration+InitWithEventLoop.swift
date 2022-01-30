//
//  CognitoConfiguration+InitWithEventLoop.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 20/01/2022.
//

import AsyncHTTPClient
import Foundation
import SotoCognitoAuthenticationKit

extension CognitoAuthenticatable {
    
    convenience init(
        eventLoop: EventLoop,
        userPoolId: String,
        clientId: String,
        clientSecret: String?,
        adminClient: Bool
    ) {
        let httpClient = HTTPClient(
            eventLoopGroupProvider: .shared(eventLoop),
            configuration: HTTPClient.Configuration(timeout: .default)
        )
        
        let client = AWSClient(httpClientProvider: .shared(httpClient))
        let cognitoIDP = CognitoIdentityProvider(client: client)
        let configuration = CognitoConfiguration(
            userPoolId: userPoolId,
            clientId: clientId,
            clientSecret: clientSecret,
            cognitoIDP: cognitoIDP,
            adminClient: adminClient
        )
        
        self.init(configuration: configuration)
    }
    
}
