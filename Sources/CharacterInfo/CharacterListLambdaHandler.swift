//
//  CharacterListLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 17/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import NIO

struct CharacterListLambdaHandler: EventLoopLambdaHandler {

    typealias In = Request
    typealias Out = Response

    private let characterListResponseWrapper: CharacterListResponseWrapper

    init(context: Lambda.InitializationContext) {
        let database = DatabaseFectory(mocked: CharacterInfo.isMocked).makeDatabase(eventLoop: context.eventLoop)
        let characterAPIService = CharacterDatabaseProvider(database: database)
        let characterRepositoryFactory = CharacterRepositoryFactory(characterAPIService: characterAPIService)
        let characterUseCase = CharacterUseCase(characterRepository: characterRepositoryFactory.makeCharacterRepository())
        characterListResponseWrapper = CharacterListResponseWrapper(characterUseCase: characterUseCase)
    }

    func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<Response> {
        if let data = try? JSONEncoder().encode(event) {
            context.logger.log(level: .info, "\(String(data: data, encoding: .utf8) ?? "")")
        }

        return characterListResponseWrapper.handleList(on: context.eventLoop)
    }

}
