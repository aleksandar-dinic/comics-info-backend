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
    let itemType: String
    let sortValue: String
    let headers: [String: String]?
    
    init(
        id: String = UUID().uuidString,
        message: String,
        email: String?,
        headers: [String: String]? = nil
    ) {
        self.itemID = .comicInfoID(for: Self.self, ID: id)
        self.message = message
        self.email = email
        self.dateAdded = Date()
        itemType = .getType(from: Self.self)
        sortValue = "Email=\(email ?? "")#ItemID=\(itemID)"
        self.headers = headers
    }
    
}

extension Feedback: CustomStringConvertible {
    
    public var description: String {
        """
        itemID = \(itemID)
        message = \(message)
        email = \(String(describing: email))
        dateAdded = \(dateAdded.toDefaultString())
        headers = \(String(describing: headers))
        """
    }
    
}
