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
    associatedtype Summary: DatabaseItemSummary where Summary.Item == Item
    associatedtype ItemDatabase: DatabaseMapper where ItemDatabase.Item == Item

    var eventLoop: EventLoop { get }
    var repositoryAPIService: CreateRepositoryAPIService { get }
    var encoderService: EncoderService { get }

    func create(_ item: Item, in table: String) -> EventLoopFuture<Void>
    func createSummaries(for item: Item, in table: String) -> EventLoopFuture<[DatabasePutItem]>

    func getSummaryFutures(for item: Item, in table: String) -> [EventLoopFuture<[DatabasePutItem]>]

}

extension CreateAPIWrapper {

    func create(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        createSummaries(for: item, in: table)
            .flatMap { repositoryAPIService.createAll($0) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }

    func createSummaries(for item: Item, in table: String) -> EventLoopFuture<[DatabasePutItem]> {
        .reduce(
            [createDatabaseItem(item, in: table)],
            getSummaryFutures(for: item, in: table), on: eventLoop
        ) { $0 + $1 }
    }

    func appendItemSummary<LinkItem: Identifiable>(
        _ linkItems: [LinkItem],
        item: Item,
        dbItems: inout [DatabasePutItem],
        tableName: String
    ) -> [DatabasePutItem] where LinkItem.ID == String {

        for linkItem in linkItems {
            let summary = Summary(
                item,
                id: linkItem.id,
                itemName: .getType(from: LinkItem.self)
            )
            dbItems.append(encoderService.encode(summary, table: tableName))
        }

        return dbItems
    }

    private func createDatabaseItem(_ item: Item, in table: String) -> DatabasePutItem {
        encoderService.encode(ItemDatabase(item: item), table: table)
    }

}
