//
//  RepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public protocol RepositoryAPIWrapper {

    associatedtype Item: Codable & Identifiable

    var eventLoop: EventLoop { get }
    var repositoryAPIService: RepositoryAPIService { get }
    var logger: Logger { get }
    var decoderService: DecoderService { get }
    var encoderService: EncoderService { get }
    var tableName: String { get }

    func create(_ item: Item) -> EventLoopFuture<Void>

    func getItem(withID itemID: Item.ID) -> EventLoopFuture<Item>
    func getAllItems() -> EventLoopFuture<[Item]>

    func getMetadata(id: Item.ID) -> EventLoopFuture<Item>
    func getAllMetadata(ids: Set<Item.ID>) -> EventLoopFuture<[Item]>

    func update(_ item: Item) -> EventLoopFuture<Void>

}
