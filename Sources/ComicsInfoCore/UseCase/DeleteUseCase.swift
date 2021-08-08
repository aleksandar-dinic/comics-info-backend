//
//  DeleteUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public protocol DeleteUseCase {

    associatedtype Item: ComicInfoItem

    var deleteRepository: DeleteRepository { get }
    
    func delete(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<Item>
    
    func deleteSummaries<Summary: ItemSummary>(
        with criteria: DeleteSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]>
    
    func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<Item>
    
}

extension DeleteUseCase {
    
    public func delete(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<Item> {
        getItem(withID: ID, on: eventLoop, from: table, logger: logger)
            .flatMap { item in
                let criteria = DeleteItemCriteria(
                    item: item,
                    on: eventLoop,
                    in: table,
                    log: logger
                )
                return deleteRepository.delete(with: criteria)
            }
    }
    
    public func deleteSummaries<Summary: ItemSummary>(
        with criteria: DeleteSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]> {
        deleteRepository.deleteSummaries(with: criteria)
    }
    
}
