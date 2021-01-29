//
//  CharacterRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct CharacterRepositoryAPIWrapper: RepositoryAPIWrapper {
    
    public let repositoryAPIService: RepositoryAPIService
    private let characterGetAPIWrapper: CharacterGetAPIWrapper
    
    init(repositoryAPIService: RepositoryAPIService) {
        self.repositoryAPIService = repositoryAPIService
        characterGetAPIWrapper = CharacterGetAPIWrapper(repositoryAPIService: repositoryAPIService)
    }

    public func getItem(withID ID: String, from table: String) -> EventLoopFuture<Character> {
        characterGetAPIWrapper.get(withID: ID, from: table)
    }
    
    public func getItems(withIDs IDs: Set<String>, from table: String) -> EventLoopFuture<[Character]> {
        characterGetAPIWrapper.getItems(withIDs: IDs, from: table)
    }

    public func getAllItems(from table: String) -> EventLoopFuture<[Character]> {
        characterGetAPIWrapper.getAll(from: table)
    }
    
    public func getSummaries<Summary: ItemSummary>(_ type: Summary.Type, forID ID: String, from table: String) -> EventLoopFuture<[Summary]?> {
        characterGetAPIWrapper.getSummaries(type, forID: ID, from: table)
    }

}
