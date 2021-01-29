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

    func getItem<Item: Codable>(withID ID: String, from table: String) -> EventLoopFuture<Item>
    func getItems<Item: ComicInfoItem>(withIDs IDs: Set<String>, from table: String) -> EventLoopFuture<[Item]>
    func getAll<Item: ComicInfoItem>(_ items: String, from table: String) -> EventLoopFuture<[Item]>
    func getSummaries<Summary: ItemSummary>(_ type: Summary.Type, forID ID: String, from table: String) -> EventLoopFuture<[Summary]?>

}
