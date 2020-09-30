//
//  UseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol UseCase {

    associatedtype Item: Codable

    func create(_ item: Item) -> EventLoopFuture<Void>

    func getItem(
        withID itemID: String,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Item>

    func getAllItems(
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]>

    func getMetadata(
        withID id: String,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Item>

    func getAllMetadata(
        withIDs ids: Set<String>,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]>

}
