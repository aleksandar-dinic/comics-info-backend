//
//  ComicUpdateRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct ComicUpdateRepositoryAPIWrapper: UpdateRepositoryAPIWrapper {

    public let repositoryAPIService: UpdateRepositoryAPIService
    private let comicUpdateAPIWrapper: ComicUpdateAPIWrapper
    
    public init(repositoryAPIService: UpdateRepositoryAPIService) {
        self.repositoryAPIService = repositoryAPIService
        comicUpdateAPIWrapper = ComicUpdateAPIWrapper(repositoryAPIService: repositoryAPIService)
    }

    public func update(_ item: Comic, in table: String) -> EventLoopFuture<Set<String>> {
        comicUpdateAPIWrapper.update(item, in: table)
    }
    
    public func updateSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        comicUpdateAPIWrapper.updateSummaries(summaries, in: table)
    }

}
