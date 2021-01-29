//
//  ComicRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct ComicRepositoryAPIWrapper: RepositoryAPIWrapper {

    public let repositoryAPIService: RepositoryAPIService
    private let comicGetAPIWrapper: ComicGetAPIWrapper
    
    init(repositoryAPIService: RepositoryAPIService) {
        self.repositoryAPIService = repositoryAPIService
        comicGetAPIWrapper = ComicGetAPIWrapper(repositoryAPIService: repositoryAPIService)
    }

    public func getItem(withID itemID: String, from table: String) -> EventLoopFuture<Comic> {
        comicGetAPIWrapper.get(withID: itemID, from: table)
    }
    
    public func getItems(withIDs IDs: Set<String>, from table: String) -> EventLoopFuture<[Comic]> {
        comicGetAPIWrapper.getItems(withIDs: IDs, from: table)
    }

    public func getAllItems(from table: String) -> EventLoopFuture<[Comic]> {
        comicGetAPIWrapper.getAll(from: table)
    }
    
    public func getSummaries<Summary: ItemSummary>(_ type: Summary.Type, forID ID: String, from table: String) -> EventLoopFuture<[Summary]?> {
        comicGetAPIWrapper.getSummaries(type, forID: ID, from: table)
    }

}
