//
//  UseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol UseCase where APIWrapper.Item == CacheService.Item {

    associatedtype APIWrapper: RepositoryAPIWrapper
    associatedtype CacheService: Cacheable

    typealias Item = APIWrapper.Item

    var repository: Repository<APIWrapper, CacheService> { get }
    var availableFields: Set<String> { get }

    func getItem(
        on eventLoop: EventLoop,
        withID ID: String,
        fields: Set<String>?,
        from table: String,
        dataSource: DataSourceLayer
    ) -> EventLoopFuture<Item>

    func getItems(
        on eventLoop: EventLoop,
        withIDs IDs: Set<Item.ID>,
        from table: String,
        dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]>
    
    func getAllItems(
        on eventLoop: EventLoop,
        from table: String,
        dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]>
    
    func getSummaries<Summary: ItemSummary>(
        _ type: Summary.Type,
        on eventLoop: EventLoop,
        forID ID: String,
        dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Summary]?>

}

public extension UseCase {
    
    func getItems(
        on eventLoop: EventLoop,
        withIDs IDs: Set<Item.ID>,
        from table: String,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<[Item]> {
        repository.getItems(withIDs: IDs, dataSource: dataSource, from: table)
            .hop(to: eventLoop)
    }

    func getAllItems(
        on eventLoop: EventLoop,
        from table: String,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<[Item]> {
        repository.getAllItems(dataSource: dataSource, from: table)
            .hop(to: eventLoop)
    }
    
    func handleFields(_ fields: Set<String>?) throws -> Set<String> {
        guard let fields = fields else { return [] }
        
        guard fields.isSubset(of: availableFields) else {
            throw APIError.invalidFields(fields.filter { !availableFields.contains($0) })
        }
        return fields
    }
    
    func getSummaries<Summary: ItemSummary>(
        _ type: Summary.Type,
        on eventLoop: EventLoop,
        forID ID: String,
        dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Summary]?> {
        repository.getSummaries(type, forID: ID, dataSource: dataSource, from: table)
            .hop(to: eventLoop)
    }

}
