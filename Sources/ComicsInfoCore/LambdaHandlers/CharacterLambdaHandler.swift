//
//  CharacterLambdaHandler.swift
//  ComicsInfoCore
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

    private let action: HandlerAction
    private let characterRepository: CharacterRepository

    init(action: HandlerAction, characterAPIService: CharacterAPIService) {
        self.action = action
        let characterRepositoryFactory = CharacterRepositoryFactory(
            characterAPIService: characterAPIService
        )
        characterRepository = characterRepositoryFactory.makeCharacterRepository()
    }

    func handle(
        context: Lambda.Context,
        event: APIGateway.V2.Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        switch action {
        case .create, .update, .delete:
            let response = APIGateway.V2.Response(statusCode: .notFound)
            return context.eventLoop.makeSucceededFuture(response)

        case .read:
            return handleRead(context: context, event: event)
        case .list:
            return handleList(context: context, event: event)
        }
    }

    private func handleRead(
        context: Lambda.Context,
        event: APIGateway.V2.Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        guard let identifier = event.pathParameters?[.identifier] else {
            let response = APIGateway.V2.Response(statusCode: .notFound)
            return context.eventLoop.makeSucceededFuture(response)
        }

        let response = characterRepository.getCharacter(withID: identifier, fromDataSource: .database, on: context.eventLoop)
            .map { APIGateway.V2.Response(with: Domain.Character(from: $0), statusCode: .ok) }
            .flatMapError { self.catchError(context: context, error: $0) }

        return response
    }

    private func handleList(
        context: Lambda.Context,
        event: APIGateway.V2.Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        characterRepository.getAllCharacters(fromDataSource: .database, on: context.eventLoop)
           .map { APIGateway.V2.Response(with: $0.map { Domain.Character(from: $0) }, statusCode: .ok) }
           .flatMapError { self.catchError(context: context, error: $0) }
    }

    private func catchError(
        context: Lambda.Context,
        error: Error
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        let response = APIGateway.V2.Response(with: error, statusCode: .notFound)

        return context.eventLoop.makeSucceededFuture(response)
    }

}