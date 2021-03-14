//
//  GetPathParameterID.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/03/2021.
//

import Foundation

protocol GetPathParameterID {
    
    func getID(from pathParameters: [String: String]?) throws -> String
    
}

extension GetPathParameterID {
    
    func getID(from pathParameters: [String: String]?) throws -> String {
        guard let id = pathParameters?["id"] else {
            throw ComicInfoError.pathParameterIDIsMissing
        }
        
        return id
    }
    
}
