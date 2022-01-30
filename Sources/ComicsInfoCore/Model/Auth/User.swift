//
//  User.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 20/01/2022.
//

import Foundation

public struct User: Codable {
    
    let identifier: UUID
    let username: String
    
    var id: String {
        identifier.uuidString
    }
    
}
