//
//  GetAllMetadataAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol GetAllMetadataAPIWrapper {

    associatedtype Item: Identifiable & DatabaseItemMapper

    var repositoryAPIService: RepositoryAPIService { get }
    var decoderService: DecoderService { get }

    func getAllMetadata(ids: Set<String>) -> EventLoopFuture<[Item]>

}

extension GetAllMetadataAPIWrapper {

    func getAllMetadata(ids: Set<String>) -> EventLoopFuture<[Item]> {
        repositoryAPIService.getAllMetadata(withIDs: mapItemsID(ids))
            .flatMapThrowing { try handleItems($0, ids: ids) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }

    private func mapItemsID(_ ids: Set<String>) -> Set<String> {
        Set(ids.map { "\(String.getType(from: Item.self))#\($0)" })
    }

    private func handleItems(_ dbItems: [DatabaseItem], ids: Set<String>) throws -> [Item] {
        var items = [Item]()

        for dbItem in dbItems {
            guard let itemDatabase: Item.DBItem = try? decoderService.decode(from: dbItem) else { continue }
            items.append(Item(from: itemDatabase))
        }

        guard !items.isEmpty else {
            throw APIError.itemsNotFound(withIDs: ids, itemType: Item.self)
        }

        return items
    }

}
