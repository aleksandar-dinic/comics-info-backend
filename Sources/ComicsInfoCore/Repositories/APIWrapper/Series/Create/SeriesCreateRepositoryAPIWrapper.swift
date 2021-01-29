//
//  SeriesCreateRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct SeriesCreateRepositoryAPIWrapper: CreateRepositoryAPIWrapper {

    public let repositoryAPIService: CreateRepositoryAPIService
    private let seriesCreateAPIWrapper: SeriesCreateAPIWrapper
    
    init(repositoryAPIService: CreateRepositoryAPIService) {
        self.repositoryAPIService = repositoryAPIService
        seriesCreateAPIWrapper = SeriesCreateAPIWrapper(repositoryAPIService: repositoryAPIService)
    }
    
    public func create(_ item: Series, in table: String) -> EventLoopFuture<Void> {
        seriesCreateAPIWrapper.create(item, in: table)
    }
    
    public func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        seriesCreateAPIWrapper.createSummaries(summaries, in: table)
    }
    
}
