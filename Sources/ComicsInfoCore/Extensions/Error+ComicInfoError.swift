//
//  Error+ComicInfoError.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension Error {

    func mapToComicInfoError<Item>(itemType: Item.Type) -> Error {
        guard let error = self as? DatabaseError else { return ComicInfoError.internalServerError }
        
        switch error {
        case let .itemAlreadyExists(withID: id):
            return ComicInfoError.itemAlreadyExists(
                withID: id.getIDFromComicInfoID(for: itemType.self),
                itemType: itemType.self
            )

        case let .itemNotFound(withID: id):
            return ComicInfoError.itemNotFound(
                withID: id.getIDFromComicInfoID(for: itemType.self),
                itemType: itemType.self
            )

        case let .itemsNotFound(withIDs: ids):
            guard let ids = ids else {
                return ComicInfoError.itemsNotFound(withIDs: nil, itemType: itemType.self)
            }
            return ComicInfoError.itemsNotFound(
                withIDs: Set(ids.map { $0.getIDFromComicInfoID(for: itemType.self) }),
                itemType: itemType.self
            )
        }
    }

}
