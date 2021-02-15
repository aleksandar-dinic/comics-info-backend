//
//  UpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public protocol UpdateUseCase {

    associatedtype Item: ComicInfoItem

    var repository: UpdateRepository { get }
    
    func update(with criteria: UpdateItemCriteria<Item>) -> EventLoopFuture<Void>

    func updateSummaries<Summary: ItemSummary>(
        with criteria: UpdateSummariesCriteria<Summary>
    ) -> EventLoopFuture<Void>
    
    func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<Item>
    
}

extension UpdateUseCase {
    
    public func updateSummaries<Summary: ItemSummary>(
        with criteria: UpdateSummariesCriteria<Summary>
    ) -> EventLoopFuture<Void> {
        repository.updateSummaries(with: criteria)
    }
    
    func updateItem(with criteria: UpdateItemCriteria<Item>) -> EventLoopFuture<Set<String>> {
        getItem(withID: criteria.item.id, on: criteria.eventLoop, from: criteria.table, logger: criteria.logger)
            .flatMap { oldItem in
                let fields = criteria.updatedFields(oldItem: oldItem)
                guard !fields.isEmpty else { return criteria.eventLoop.submit { fields } }
                var newItem = oldItem
                newItem.update(with: criteria.item)
                let criteria = UpdateItemCriteria(item: newItem, on: criteria.eventLoop, in: criteria.table)
                return repository.update(with: criteria)
            }
    }
    
}
