//
//  CharacterLambdaHandler.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import AWSLambdaRuntime
import struct Domain.Character
import Foundation
import NIO

struct CharacterLambdaHandler {

    private let characterService: CharacterService

    init(database: Database) {
        characterService = CharacterService(database: database)
    }

    func handle(
        context: Lambda.Context,
        event: APIGateway.V2.Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        switch (event.context.http.path, event.context.http.method)  {
        case ("/characters", .GET):
             let response = characterService.getAllCharacters()
                .map { APIGateway.V2.Response(with: $0.map { Domain.Character(from: $0) }, statusCode: .ok) }
                .flatMapError { self.catchError(context: context, error: $0) }

            return response

        default:
            let response = APIGateway.V2.Response(statusCode: .notFound)

            return context.eventLoop.makeSucceededFuture(response)
        }
    }

    private func catchError(
        context: Lambda.Context,
        error: Error
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        let response = APIGateway.V2.Response(with: error, statusCode: .notFound)

        return context.eventLoop.makeSucceededFuture(response)
    }

}
