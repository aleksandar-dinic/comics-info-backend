//
//  Feedback.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//

import Foundation

struct Feedback: Codable {
    
    let itemID: String
    let message: String
    let email: String?
    let dateAdded: Date
    let sortValue: String
    
    init(
        id: String = UUID().uuidString,
        message: String,
        email: String?
    ) {
        self.itemID = .comicInfoID(for: Self.self, ID: id)
        self.message = message
        self.email = email
        self.dateAdded = Date()
        self.sortValue = "Email=\(email ?? "")#ItemID=\(itemID)"
    }
    
}
