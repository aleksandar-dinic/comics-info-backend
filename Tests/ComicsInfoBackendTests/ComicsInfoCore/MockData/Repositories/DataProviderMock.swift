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
        cacheProvider: InMemoryCacheProvider<Character> = InMemoryCacheProvider<Character>()
    ) -> DataProvider<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> {
        let repositoryAPIWrapper = RepositoryAPIWrapperMock.makeCharacterRepositoryAPIWrapper(
            on: eventLoop,
            logger: Logger(label: "DataProviderMock")
        )
        return DataProvider(
            on: eventLoop,
            repositoryAPIWrapper: repositoryAPIWrapper,
            cacheProvider: cacheProvider
        )
    }

}
