//
//  CharacterReadResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import struct Logging.Logger
import Foundation
import NIO

public struct CharacterReadResponseWrapper: ReadResponseWrapper {

    private let characterUseCase: CharacterUseCase

    public init(characterUseCase: CharacterUseCase) {
        self.characterUseCase = characterUseCase
    }

    public func handleRead(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response> {
        guard let id = try? request.getIDFromPathParameters() else {
            return handleList(
                on: eventLoop,
                request: request,
                environment: environment,
                logger: logger
            )
        }
        
        let fields = getFields(from: request.queryParameters)

        let table = String.tableName(for: environment)
        return characterUseCase.getItem(on: eventLoop, withID: id, fields: fields, from: table, logger: logger)
            .map { Response(with: Domain.Character(from: $0), statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
    }
    
    private func handleList(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response> {
        do {
            return characterUseCase.getAllItems(
                on: eventLoop,
                afterID: request.getAfterIDFromQueryParameters(),
                fields: getFields(from: request.queryParameters),
                limit: try request.getLimitFromQueryParameters(),
                from: String.tableName(for: environment),
                logger: logger
            )
                .map { Response(with: $0.map { Domain.Character(from: $0) }, statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
        } catch {
            guard let responseError = error as? ComicInfoError else {
                let message = ResponseMessage(error.localizedDescription)
                return eventLoop.submit { Response(with: message, statusCode: .badRequest) }
            }
            
            let message = ResponseMessage(for: responseError)
            return eventLoop.submit { Response(with: message, statusCode: responseError.responseStatus) }
        }
    }
    
}
