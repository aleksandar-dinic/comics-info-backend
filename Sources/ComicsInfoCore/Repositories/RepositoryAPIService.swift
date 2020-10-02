//
//  RepositoryAPIService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol RepositoryAPIService {

    func create(_ item: DatabaseItem) -> EventLoopFuture<Void>
    func createAll(_ items: [DatabaseItem]) -> EventLoopFuture<Void>

    func getItem(withID itemID: String) -> EventLoopFuture<[DatabaseItem]>
    func getAll(_ items: String) -> EventLoopFuture<[DatabaseItem]>

    func getMetadata(withID id: String) -> EventLoopFuture<DatabaseItem>
    func getAllMetadata(withIDs ids: Set<String>) -> EventLoopFuture<[DatabaseItem]>

}
