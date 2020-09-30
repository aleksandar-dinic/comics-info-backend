//
//  RepositoryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct RepositoryFactory<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable>: DataProviderFactory where APIWrapper.Item == CacheProvider.Item {

    public let eventLoop: EventLoop
    public let repositoryAPIWrapper: APIWrapper
    public let cacheProvider: CacheProvider
    public let decoderService: DecoderService
    public let encoderService: EncoderService

    public init(
        on eventLoop: EventLoop,
        repositoryAPIWrapper: APIWrapper,
        cacheProvider: CacheProvider,
        decoderService: DecoderService = DecoderProvider(),
        encoderService: EncoderService = EncoderProvider()
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIWrapper = repositoryAPIWrapper
        self.cacheProvider = cacheProvider
        self.decoderService = decoderService
        self.encoderService = encoderService
    }

    public func makeRepository() -> Repository<APIWrapper, CacheProvider> {
        Repository(dataProvider: makeDataProvider())
    }

}
