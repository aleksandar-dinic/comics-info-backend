//
//  String+Database.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation

public extension String {

    static func tableName(for environment: String?) -> String {
        Lambda.tableName(for: environment) ?? ""
    }

    static func getType(from item: Any.Type) -> String {
        "\(item.self)"
    }
    
    static func comicInfoID<Item: Identifiable>(for item: Item) -> String {
        "\(String.getType(from: Item.self))#\(item.id)"
    }
    
    static func comicInfoSummaryID<Item: Identifiable>(for item: Item) -> String {
        "\(String.getType(from: Item.self))Summary#\(item.id)"
    }
    
    static func comicInfoID<Item>(for item: Item.Type, ID: String) -> String {
        "\(String.getType(from: Item.self))#\(ID)"
    }
    
    func getIDFromComicInfoID(for item: Any.Type) -> String {
        self.replacingOccurrences(of: "\(String.getType(from: item.self))#", with: "")
    }
    
    static var email: String {
        Lambda.email ?? ""
    }
    
    static var feedbackSubject: String {
        "ComicsInfo Feedback"
    }

}
