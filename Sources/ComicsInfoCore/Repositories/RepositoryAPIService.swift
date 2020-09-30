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
    func createAll(_ items: [String: [[String: Any]]]) -> EventLoopFuture<Void>

    func getItem(withID itemID: String) -> EventLoopFuture<[[String: Any]]?>
    func getAllItems() -> EventLoopFuture<[[String: Any]]?>

    func getMetadata(id: String) -> EventLoopFuture<[String: Any]?>
    func getAllMetadata(ids: Set<String>) -> EventLoopFuture<[[String: Any]]?>

}
