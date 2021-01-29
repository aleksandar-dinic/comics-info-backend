//
//  CharacterUpdateRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct CharacterUpdateRepositoryAPIWrapper: UpdateRepositoryAPIWrapper {

    public let repositoryAPIService: UpdateRepositoryAPIService
    private let characterUpdateAPIWrapper: CharacterUpdateAPIWrapper
    
    public init(repositoryAPIService: UpdateRepositoryAPIService) {
        self.repositoryAPIService = repositoryAPIService
        characterUpdateAPIWrapper = CharacterUpdateAPIWrapper(repositoryAPIService: repositoryAPIService)
    }

    public func update(_ item: Character, in table: String) -> EventLoopFuture<Set<String>> {
        characterUpdateAPIWrapper.update(item, in: table)
    }
    
    public func updateSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        characterUpdateAPIWrapper.updateSummaries(summaries, in: table)
    }
    
}
