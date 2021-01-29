//
//  SeriesRepositoryAPIWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 27/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct SeriesRepositoryAPIWrapper: RepositoryAPIWrapper {

    public let repositoryAPIService: RepositoryAPIService
    private let seriesGetAPIWrapper: SeriesGetAPIWrapper
    
    init(repositoryAPIService: RepositoryAPIService) {
        self.repositoryAPIService = repositoryAPIService
        seriesGetAPIWrapper = SeriesGetAPIWrapper(repositoryAPIService: repositoryAPIService)
    }

    public func getItem(withID ID: String, from table: String) -> EventLoopFuture<Series> {
        seriesGetAPIWrapper.get(withID: ID, from: table)
    }
    
    public func getItems(withIDs IDs: Set<String>, from table: String) -> EventLoopFuture<[Series]> {
        seriesGetAPIWrapper.getItems(withIDs: IDs, from: table)
    }

    public func getAllItems(from table: String) -> EventLoopFuture<[Series]> {
        seriesGetAPIWrapper.getAll(from: table)
    }
    
    public func getSummaries<Summary: ItemSummary>(_ type: Summary.Type, forID ID: String, from table: String) -> EventLoopFuture<[Summary]?> {
        seriesGetAPIWrapper.getSummaries(type, forID: ID, from: table)
    }

}
