//
//  CharacterCreateRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct CharacterCreateRepositoryAPIWrapper: CreateRepositoryAPIWrapper {

    public let repositoryAPIService: CreateRepositoryAPIService
    private let characterCreateAPIWrapper: CharacterCreateAPIWrapper
    
    init(repositoryAPIService: CreateRepositoryAPIService) {
        self.repositoryAPIService = repositoryAPIService
        characterCreateAPIWrapper = CharacterCreateAPIWrapper(repositoryAPIService: repositoryAPIService)
    }
    
    public func create(_ item: Character, in table: String) -> EventLoopFuture<Void> {
        characterCreateAPIWrapper.create(item, in: table)
    }
    
    public func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        characterCreateAPIWrapper.createSummaries(summaries, in: table)
    }

}
