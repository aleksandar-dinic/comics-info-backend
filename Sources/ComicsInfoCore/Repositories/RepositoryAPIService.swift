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

    func create(_ item: [String: Any]) -> EventLoopFuture<Void>

    func getAll(on eventLoop: EventLoop) -> EventLoopFuture<[[String: Any]]?>

    func get<ID: Hashable>(
        withID identifier: ID,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[String: Any]?>

}
