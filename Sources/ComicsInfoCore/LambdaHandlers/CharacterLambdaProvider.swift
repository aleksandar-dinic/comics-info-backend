//
//  CharacterLambdaProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterLambdaProvider {

    private let characterLambdaHandler: CharacterLambdaHandler

    init(database: Database, action: HandlerAction) {
        let characterAPIService = CharacterDatabaseProvider(database: database)
        characterLambdaHandler = CharacterLambdaHandler(action: action, characterAPIService: characterAPIService)
    }

    func handle(
        on eventLoop: EventLoop,
        request: Request
    ) -> EventLoopFuture<Response> {
        return characterLambdaHandler.handle(on: eventLoop, request: request)
    }
    
}
