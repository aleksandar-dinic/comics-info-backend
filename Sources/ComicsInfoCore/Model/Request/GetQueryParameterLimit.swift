//
//  GetQueryParameterLimit.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/03/2021.
//

import Foundation

protocol GetQueryParameterLimit {
    
    func getLimit(from queryParameters: [String: String]?) throws -> Int
    
}

extension GetQueryParameterLimit {
    
    func getLimit(from queryParameters: [String: String]?) throws -> Int {
        guard let limitString = queryParameters?["limit"] else {
            return .queryLimit
        }
        
        guard let limit = Int(limitString), limit > 0 else {
            throw ComicInfoError.invalidQueryParameterLimit(
                message: "You must pass an integer limit greater than 0."
            )
        }
        
        guard limit <= .queryLimit else {
            throw ComicInfoError.invalidQueryParameterLimit(
                message: "You may not request more than \(Int.queryLimit) items."
            )
        }
        
        return limit
    }
    
}
