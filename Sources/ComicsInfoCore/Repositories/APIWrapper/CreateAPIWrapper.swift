//
//  CreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateAPIWrapper {

    associatedtype Item
    associatedtype Summary: ItemSummary where Summary.Item == Item
    associatedtype ItemDatabase: DatabaseMapper where ItemDatabase.Item == Item

    var eventLoop: EventLoop { get }
    var repositoryAPIService: RepositoryAPIService { get }
    var encoderService: EncoderService { get }
    var tableName: String { get }

    func create(_ item: Item) -> EventLoopFuture<Void>
    func createSummaries(for item: Item) -> EventLoopFuture<[DatabasePutItem]>

    func getSummaryFutures(for item: Item) -> [EventLoopFuture<[DatabasePutItem]>]

}

extension CreateAPIWrapper {

    func create(_ item: Item) -> EventLoopFuture<Void> {
        createSummaries(for: item)
            .flatMap { repositoryAPIService.createAll($0) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }

    func createSummaries(for item: Item) -> EventLoopFuture<[DatabasePutItem]> {
        .reduce([createDatabaseItem(item)], getSummaryFutures(for: item), on: eventLoop) { $0 + $1 }
    }

    func appendItemSummary<LinkItem: Identifiable>(
        _ linkItems: [LinkItem],
        item: Item,
        dbItems: inout [DatabasePutItem]
    ) -> [DatabasePutItem] where LinkItem.ID == String {

        for linkItem in linkItems {
            let summary = Summary(
                item,
                id: linkItem.id,
                itemName: .getType(from: LinkItem.self),
                tableName: tableName
            )
            dbItems.append(encoderService.encode(summary))
        }

        return dbItems
    }

    private func createDatabaseItem(_ item: Item) -> DatabasePutItem {
        encoderService.encode(ItemDatabase(item: item, tableName: tableName))
    }

}
