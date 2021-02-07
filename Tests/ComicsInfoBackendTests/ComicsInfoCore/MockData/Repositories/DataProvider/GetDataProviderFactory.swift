//
//  GetDataProviderFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

enum GetDataProviderFactory {
    
    static func make(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        cacheProvider: TestCache<MockComicInfoItem> = TestCache(),
        items: [String: Data] = [:]
    ) -> GetDataProvider<MockComicInfoItem, TestCache<MockComicInfoItem>> {
        GetDataProvider(
            eventLoop: eventLoop,
            itemGetDBWrapper: ItemGetDBWrapperFactory.make(items: items),
            cacheProvider: cacheProvider
        )
    }
    
}
