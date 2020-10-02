//
//  DatabaseError.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

enum DatabaseError: Error {

    case itemDoesNotHaveID
    case itemAlreadyExists(withID: String)

    case itemNotFound(withID: String)
    case itemsNotFound(withIDs: Set<String>?)

}
