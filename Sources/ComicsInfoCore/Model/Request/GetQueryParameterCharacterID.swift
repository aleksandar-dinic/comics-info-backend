//
//  GetQueryParameterCharacterID.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/08/2021.
//

import Foundation

protocol GetQueryParameterCharacterID {
    
    func getCharacterID(from queryParameters: [String: String]?) throws -> String
    func getCharacterSummaryID(from queryParameters: [String: String]?) throws -> String
    
}

extension GetQueryParameterCharacterID {
    
    func getCharacterID(from queryParameters: [String: String]?) throws -> String {
        guard let characterID = queryParameters?["characterID"] else {
            throw ComicInfoError.queryParameterIsMissing(type: Character.self)
        }
        
        return characterID
    }
    
    func getCharacterSummaryID(from queryParameters: [String: String]?) throws -> String {
        guard let characterSummaryID = queryParameters?["characterID"] else {
            throw ComicInfoError.queryParameterIsMissing(type: Character.self)
        }
        
        return .comicInfoID(for: CharacterSummary.self, ID: characterSummaryID)
    }
    
}

