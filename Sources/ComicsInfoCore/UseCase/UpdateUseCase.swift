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

    func appendItemSummary(
        _ item: Item,
        on eventLoop: EventLoop,
        from table: String
    ) -> EventLoopFuture<Item>
    
    func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String
    ) -> EventLoopFuture<Item>
    
    func updateSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void>
    func updateExistingSummaries(for item: Item, on eventLoop: EventLoop, fields: Set<String>, in table: String) -> EventLoopFuture<Bool>

}

extension UpdateUseCase {
    
    public func update(_ item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        appendItemSummary(item, on: eventLoop, from: table)
            .flatMap { updateItem($0, on: eventLoop, in: table) }
            .hop(to: eventLoop)
    }
    
    private func updateItem(_ item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        getItem(withID: item.id, on: eventLoop, from: table)
            .flatMap { oldItem in
                let fields = item.updatedFields(old: oldItem)
                guard !fields.isEmpty else { return eventLoop.submit { fields } }
                var newItem = oldItem
                newItem.update(with: item)
                return repository.update(newItem, in: table)
            }
            .flatMap { fields in
                updateSummaries(for: item, on: eventLoop, in: table)
                    .and(updateExistingSummaries(for: item, on: eventLoop, fields: fields, in: table))
                    .map { _ in }
            }
    }
    
    func updateSummaries<Summary: ItemSummary>(
        _ summaries: [Summary]?,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void> {
        guard let summaries = summaries else { return eventLoop.submit { } }
        return repository.updateSummaries(summaries, in: table)
    }
    
}
