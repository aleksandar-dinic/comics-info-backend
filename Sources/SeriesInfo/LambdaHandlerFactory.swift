//
//  LambdaHandlerFactory.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 25/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import NIO

enum LambdaHandlerFactory {

    static func makeReadLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let seriesUseCaseFactory = makeSeriesUseCaseFactory(on: context.eventLoop)
        let readResponseWrapper = SeriesReadResponseWrapper(seriesUseCase: seriesUseCaseFactory.makeUseCase())

        return ReadLambdaHandler(context, readResponseWrapper: readResponseWrapper)
    }

    static func makeListLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let seriesUseCaseFactory = makeSeriesUseCaseFactory(on: context.eventLoop)
        let listResponseWrapper = SeriesListResponseWrapper(seriesUseCase: seriesUseCaseFactory.makeUseCase())

        return ListLambdaHandler(context, listResponseWrapper: listResponseWrapper)
    }

    static func makeCreateLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let seriesUseCaseFactory = makeSeriesUseCaseFactory(on: context.eventLoop)
        return CreateLambdaHandler(context, useCase: seriesUseCaseFactory.makeUseCase())
    }

    private static func makeSeriesUseCaseFactory(
        on eventLoop: EventLoop
    ) -> SeriesUseCaseFactory<InMemoryCacheProvider<Series>> {
        SeriesUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: SeriesInfo.seriesInMemoryCache
        )
    }

}
