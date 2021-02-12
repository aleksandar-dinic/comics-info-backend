//
//  UpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol UpdateUseCase {

    associatedtype Item: ComicInfoItem

    var repository: UpdateRepository { get }
    
    func update(_ item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void>

    func updateSummaries<Summary: ItemSummary>(
        _ summaries: [Summary],
        in table: String,
        strategy: UpdateSummariesStrategy
    ) -> EventLoopFuture<Void>
    
    func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String
    ) -> EventLoopFuture<Item>
    
}

extension UpdateUseCase {
    
    public func updateSummaries<Summary: ItemSummary>(
        _ summaries: [Summary],
        in table: String,
        strategy: UpdateSummariesStrategy = .default
    ) -> EventLoopFuture<Void> {
        repository.updateSummaries(summaries, in: table, strategy: strategy)
    }
    
    func updateItem(_ item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Set<String>> {
        getItem(withID: item.id, on: eventLoop, from: table)
            .flatMap { oldItem in
                let fields = item.updatedFields(old: oldItem)
                guard !fields.isEmpty else { return eventLoop.submit { fields } }
                var newItem = oldItem
                newItem.update(with: item)
                return repository.update(newItem, in: table)
            }
    }
    
}
