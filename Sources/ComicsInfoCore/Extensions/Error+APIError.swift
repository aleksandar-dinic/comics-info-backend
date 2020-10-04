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
        case .itemDoesNotHaveID:
            return APIError.requestError

        case let .itemAlreadyExists(withID: id):
            return APIError.itemAlreadyExists(withID: id, itemType: itemType.self)

        case let .itemNotFound(withID: id):
            return APIError.itemNotFound(withID: id, itemType: itemType.self)

        case let .itemsNotFound(withIDs: ids):
            return APIError.itemsNotFound(withIDs: ids, itemType: itemType.self)
        }
    }

}
