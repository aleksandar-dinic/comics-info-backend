//
//  Error+APIError.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension Error {

    func mapToAPIError<Item: Identifiable>(itemType: Item.Type) -> Error {
        guard let error = self as? DatabaseError else { return self }
        
        switch error {
        case let .itemAlreadyExists(withID: id):
            return APIError.itemAlreadyExists(
                withID: id.replacingOccurrences(of: "\(String.getType(from: itemType.self))#", with: ""),
                itemType: itemType.self
            )

        case let .itemNotFound(withID: id):
            return APIError.itemNotFound(
                withID: id.replacingOccurrences(of: "\(String.getType(from: itemType.self))#", with: ""),
                itemType: itemType.self
            )

        case let .itemsNotFound(withIDs: ids):
            guard let ids = ids else {
                return APIError.itemsNotFound(withIDs: nil, itemType: itemType.self)
            }
            return APIError.itemsNotFound(
                withIDs: Set(ids.map { $0.replacingOccurrences(of: "\(String.getType(from: itemType.self))#", with: "") }),
                itemType: itemType.self
            )
        }
    }

}
