//
//  UpdateLambdaHandlerFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation
import protocol NIO.EventLoop

enum UpdateLambdaHandlerFactory {
    
    // Character

    static func makeCharacterHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeCharacterUpdateUseCaseFactory(on: context.eventLoop)
        let updateResponseWrapper = CharacterUpdateResponseWrapper(
            characterUseCase: useCaseFactory.makeUseCase()
        )

        return UpdateLambdaHandler(context, updateResponseWrapper: updateResponseWrapper)
    }

    private static func makeCharacterUpdateUseCaseFactory(on eventLoop: EventLoop) -> CharacterUpdateUseCaseFactory {
        CharacterUpdateUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
    }
    
    // Comic
    
    static func makeComicHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeComicUseCaseFactory(on: context.eventLoop)
        let updateResponseWrapper = ComicUpdateResponseWrapper(comicUseCase: useCaseFactory.makeUseCase())

        return UpdateLambdaHandler(context, updateResponseWrapper: updateResponseWrapper)
    }

    private static func makeComicUseCaseFactory(on eventLoop: EventLoop) -> ComicUpdateUseCaseFactory {
        ComicUpdateUseCaseFactory(on: eventLoop, isLocalServer: LocalServer.isEnabled)
    }
    
    // Series
    
    static func makeSeriesHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeSeriesUseCaseFactory(on: context.eventLoop)
        let updateResponseWrapper = SeriesUpdateResponseWrapper(seriesUseCase: useCaseFactory.makeUseCase())

        return UpdateLambdaHandler(context, updateResponseWrapper: updateResponseWrapper)
    }

    private static func makeSeriesUseCaseFactory(on eventLoop: EventLoop) -> SeriesUpdateUseCaseFactory {
        SeriesUpdateUseCaseFactory(on: eventLoop, isLocalServer: LocalServer.isEnabled)
    }

}
