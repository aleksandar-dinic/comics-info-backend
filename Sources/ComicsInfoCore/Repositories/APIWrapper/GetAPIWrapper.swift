//
//  GetAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol GetAPIWrapper {

    associatedtype Item: ComicInfoItem

    var repositoryAPIService: RepositoryAPIService { get }

    func get(withID ID: String, from table: String) -> EventLoopFuture<Item>
    func getItems(withIDs IDs: Set<Item.ID>, from table: String) -> EventLoopFuture<[Item]>
    func getAll(from table: String) -> EventLoopFuture<[Item]>
    func getSummaries<Summary: ItemSummary>(_ type: Summary.Type, forID ID: String, from table: String) -> EventLoopFuture<[Summary]?>

}

extension GetAPIWrapper {
    
    func get(withID ID: String, from table: String) -> EventLoopFuture<Item> {
        repositoryAPIService.getItem(withID: mapToDatabaseID(ID), from: table)
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }

    func getItems(withIDs IDs: Set<Item.ID>, from table: String) -> EventLoopFuture<[Item]> {
        repositoryAPIService.getItems(withIDs: Set(IDs.map { mapToDatabaseID($0) }), from: table)
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }
    
    func mapToDatabaseID(_ ID: String, itemType: Any.Type = Item.self) -> String {
        "\(String.getType(from: itemType))#\(ID)"
    }
    
    func getAll(from table: String) -> EventLoopFuture<[Item]> {
        repositoryAPIService.getAll(.getType(from: Item.self), from: table)
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }
    
    func getSummaries<Summary: ItemSummary>(_ type: Summary.Type, forID ID: String, from table: String) -> EventLoopFuture<[Summary]?> {
        repositoryAPIService.getSummaries(type, forID: ID, from: table)
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }

}
