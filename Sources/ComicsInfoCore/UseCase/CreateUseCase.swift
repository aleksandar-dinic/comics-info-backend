//
//  CreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol CreateUseCase {

    associatedtype APIWrapper: CreateRepositoryAPIWrapper

    typealias Item = APIWrapper.Item

    var repository: CreateRepository<APIWrapper> { get }

    func create(_ item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void>
    func createSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void>
    
    func appendItemSummary(on item: Item, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Item>
    
}

extension CreateUseCase {
    
    public func create(_ item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        appendItemSummary(on: item, on: eventLoop, from: table)
            .flatMap { createItemAndSummaries($0, on: eventLoop, in: table) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }

    private func createItemAndSummaries(_ item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        repository.create(item, in: table)
            .flatMap { createSummaries(for: item, on: eventLoop, in: table) }
    }

}
