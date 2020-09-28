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

    func getAll(
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Item]>

    func get(
        withID identifier: String,
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item>

}
