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
    
    func appendItemSummary(
        _ item: Item,
        on eventLoop: EventLoop,
        from table: String
    ) -> EventLoopFuture<Item>
    
    func updateSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void>
    func updateExistingSummaries(for item: Item, on eventLoop: EventLoop, fields: Set<String>, in table: String) -> EventLoopFuture<Void>

}

extension UpdateUseCase {
    
    public func update(_ item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        appendItemSummary(item, on: eventLoop, from: table)
            .flatMap { updateItem($0, on: eventLoop, in: table) }
    }
    
    func updateItem(_ item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        repository.update(item, in: table)
            .hop(to: eventLoop)
            .flatMap { fields in
                updateSummaries(for: item, on: eventLoop, in: table)
                    .and(updateExistingSummaries(for: item, on: eventLoop, fields: fields, in: table))
                    .flatMap { _ in eventLoop.makeSucceededFuture(()) }
            }
    }
    
    func updateSummaries<Summary: ItemSummary>(
        _ summaries: [Summary]?,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void> {
        guard let summaries = summaries else { return eventLoop.makeSucceededFuture(()) }
        return repository.updateSummaries(summaries, in: table)
            .hop(to: eventLoop)
    }
    
}
