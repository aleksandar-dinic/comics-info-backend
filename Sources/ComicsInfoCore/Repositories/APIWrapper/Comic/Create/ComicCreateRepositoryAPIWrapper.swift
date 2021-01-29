//
//  ComicCreateRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct ComicCreateRepositoryAPIWrapper: CreateRepositoryAPIWrapper {

    public let repositoryAPIService: CreateRepositoryAPIService
    private let comicCreateAPIWrapper: ComicCreateAPIWrapper
    
    init(repositoryAPIService: CreateRepositoryAPIService) {
        self.repositoryAPIService = repositoryAPIService
        comicCreateAPIWrapper = ComicCreateAPIWrapper(repositoryAPIService: repositoryAPIService)
    }
    
    public func create(_ item: Comic, in table: String) -> EventLoopFuture<Void> {
        comicCreateAPIWrapper.create(item, in: table)
    }
    
    public func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        comicCreateAPIWrapper.createSummaries(summaries, in: table)
    }
    
}
