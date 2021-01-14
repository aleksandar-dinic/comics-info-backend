//
//  DataProviderMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum DataProviderMock {

    static func makeCharacterDataProvider(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        cacheProvider: InMemoryCacheProvider<Character> = InMemoryCacheProvider<Character>(),
        items: [String: TableMock]
    ) -> DataProvider<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> {
        let repositoryAPIWrapper = RepositoryAPIWrapperMock.makeCharacterRepositoryAPIWrapper(
            on: eventLoop,
            logger: Logger(label: "DataProviderMock"),
            items: items
        )
        return DataProvider(
            eventLoop: eventLoop,
            repositoryAPIWrapper: repositoryAPIWrapper,
            cacheProvider: cacheProvider
        )
    }
    
    static func makeCharacterUpdateDataProvider(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        items: [String: TableMock]
    ) -> UpdateDataProvider<CharacterUpdateRepositoryAPIWrapper> {
        let repositoryAPIWrapper = RepositoryAPIWrapperMock.makeCharacterRepositoryUpdateAPIWrapper(
            on: eventLoop,
            logger: Logger(label: "UpdateDataProviderMock"),
            items: items
        )
        return UpdateDataProvider(repositoryAPIWrapper: repositoryAPIWrapper)
    }
    
    static func makeCharacterCreateDataProvider(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
    ) -> CreateDataProvider<CharacterCreateRepositoryAPIWrapper> {
        let repositoryAPIWrapper = RepositoryAPIWrapperMock.makeCharacterRepositoryCreateAPIWrapper(
            on: eventLoop,
            logger: Logger(label: "CreateDataProviderMock")
        )
        return CreateDataProvider(repositoryAPIWrapper: repositoryAPIWrapper)
    }

}
