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
        let useCaseFactory = CharacterUpdateUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
        let updateResponseWrapper = CharacterUpdateResponseWrapper(
            characterUseCase: useCaseFactory.makeUseCase()
        )

        return UpdateLambdaHandler(context, updateResponseWrapper: updateResponseWrapper)
    }

    // Comic
    
    static func makeComicHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = ComicUpdateUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
        let updateResponseWrapper = ComicUpdateResponseWrapper(comicUseCase: useCaseFactory.makeUseCase())

        return UpdateLambdaHandler(context, updateResponseWrapper: updateResponseWrapper)
    }

    // Series
    
    static func makeSeriesHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = SeriesUpdateUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
        let updateResponseWrapper = SeriesUpdateResponseWrapper(seriesUseCase: useCaseFactory.makeUseCase())

        return UpdateLambdaHandler(context, updateResponseWrapper: updateResponseWrapper)
    }

}
