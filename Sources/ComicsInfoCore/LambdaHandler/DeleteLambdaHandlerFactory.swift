//
//  DeleteLambdaHandlerFactory.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 21/05/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation
import protocol NIO.EventLoop

enum DeleteLambdaHandlerFactory {
    
    // Character

    static func makeCharacterHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = CharacterDeleteUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
        let deleteResponseWrapper = CharacterDeleteResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )

        return DeleteLambdaHandler(context, deleteResponseWrapper: deleteResponseWrapper)
    }

    // Comic
    
    static func makeComicHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = ComicDeleteUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
        let deleteResponseWrapper = ComicDeleteResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )

        return DeleteLambdaHandler(context, deleteResponseWrapper: deleteResponseWrapper)
    }

    // Series
    
    static func makeSeriesHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = SeriesDeleteUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
        let deleteResponseWrapper = SeriesDeleteResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )

        return DeleteLambdaHandler(context, deleteResponseWrapper: deleteResponseWrapper)
    }

}
