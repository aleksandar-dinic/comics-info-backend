//
//  SeriesUpdateRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct SeriesUpdateRepositoryAPIWrapper: UpdateRepositoryAPIWrapper {

    public let repositoryAPIService: UpdateRepositoryAPIService
    private let seriesUpdateAPIWrapper: SeriesUpdateAPIWrapper
    
    init(repositoryAPIService: UpdateRepositoryAPIService) {
        self.repositoryAPIService = repositoryAPIService
        seriesUpdateAPIWrapper = SeriesUpdateAPIWrapper(repositoryAPIService: repositoryAPIService)
    }

    public func update(_ item: Series, in table: String) -> EventLoopFuture<Set<String>> {
        seriesUpdateAPIWrapper.update(item, in: table)
    }
    
    public func updateSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        seriesUpdateAPIWrapper.updateSummaries(summaries, in: table)
    }

}
