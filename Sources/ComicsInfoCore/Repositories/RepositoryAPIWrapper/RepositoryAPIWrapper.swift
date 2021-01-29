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

    func getItem(withID ID: Item.ID, from table: String) -> EventLoopFuture<Item>
    func getItems(withIDs IDs: Set<Item.ID>, from table: String) -> EventLoopFuture<[Item]>
    func getAllItems(from table: String) -> EventLoopFuture<[Item]>
    func getSummaries<Summary: ItemSummary>(_ type: Summary.Type, forID ID: String, from table: String) -> EventLoopFuture<[Summary]?>

}
