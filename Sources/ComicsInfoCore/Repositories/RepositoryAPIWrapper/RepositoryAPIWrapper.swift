//
//  RepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol RepositoryAPIWrapper {

    associatedtype Item: Codable & Identifiable

    var repositoryAPIService: RepositoryAPIService { get }
    var decoderService: DecoderService { get }

    func getItem(withID itemID: Item.ID, from table: String) -> EventLoopFuture<Item>
    func getAllItems(from table: String) -> EventLoopFuture<[Item]>

    func getMetadata(id: Item.ID, from table: String) -> EventLoopFuture<Item>
    func getAllMetadata(ids: Set<Item.ID>, from table: String) -> EventLoopFuture<[Item]>

}
