//
//  Database.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol Database {

    mutating func create(_ item: [String: Any], tableName table: String) -> EventLoopFuture<Void>
    mutating func createAll(_ items: [String: [[String: Any]]]) -> EventLoopFuture<Void>

    func getItem(fromTable table: String, itemID: String) -> EventLoopFuture<[[String: Any]]?>
    func getAllItems(fromTable table: String) -> EventLoopFuture<[[String: Any]]?>

    func getMetadata(fromTable table: String, id: String) -> EventLoopFuture<[String: Any]?>
    func getAllMetadata(fromTable table: String, ids: Set<String>) -> EventLoopFuture<[[String: Any]]?>

}
