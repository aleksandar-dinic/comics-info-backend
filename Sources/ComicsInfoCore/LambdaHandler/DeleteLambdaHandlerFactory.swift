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
        let useCaseFactory = makeCharacterDeleteUseCaseFactory(on: context.eventLoop)
        let deleteResponseWrapper = CharacterDeleteResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )

        return DeleteLambdaHandler(context, deleteResponseWrapper: deleteResponseWrapper)
    }

    private static func makeCharacterDeleteUseCaseFactory(on eventLoop: EventLoop) -> CharacterDeleteUseCaseFactory {
        CharacterDeleteUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
    }
    
    // Comic
    
    static func makeComicHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeComicDeleteUseCaseFactory(on: context.eventLoop)
        let deleteResponseWrapper = ComicDeleteResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )

        return DeleteLambdaHandler(context, deleteResponseWrapper: deleteResponseWrapper)
    }

    private static func makeComicDeleteUseCaseFactory(on eventLoop: EventLoop) -> ComicDeleteUseCaseFactory {
        ComicDeleteUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
    }

    // Series
    
    static func makeSeriesHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeSeriesDeleteUseCaseFactory(on: context.eventLoop)
        let deleteResponseWrapper = SeriesDeleteResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )

        return DeleteLambdaHandler(context, deleteResponseWrapper: deleteResponseWrapper)
    }

    private static func makeSeriesDeleteUseCaseFactory(on eventLoop: EventLoop) -> SeriesDeleteUseCaseFactory {
        SeriesDeleteUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
    }
    
}
