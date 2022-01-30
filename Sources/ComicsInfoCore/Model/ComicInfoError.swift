//
//  ComicInfoError.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public enum ComicInfoError: Error {

    case requestError
    case itemAlreadyExists(withID: String, itemType: Any.Type)
    case itemNotFound(withID: String, itemType: Any.Type)
    case itemsNotFound(withIDs: Set<String>?, itemType: Any.Type)
    case summariesAlreadyExist(_ IDs: Set<String>)
    case invalidFields(_ fields: Set<String>)
    case requestBodyIsMissing
    case pathParameterIDIsMissing
    case queryParameterIsMissing(type: Any.Type)
    case userIDIsMissing
    case invalidQueryParameterLimit(message: String)
    case invalidQueryParameterOffset(message: String)
    case cannotUpdateItemID(type: Any.Type)
    case handlerUnknown
    case unauthorized
    case internalServerError

}

extension ComicInfoError {
    
    var responseStatus: HTTPResponseStatus {
        switch self {
        case .itemAlreadyExists, .summariesAlreadyExist:
            return .conflict
            
        case .itemNotFound, .itemsNotFound:
            return .noContent
            
        case .queryParameterIsMissing:
            return .methodNotAllowed
            
        case .handlerUnknown, .internalServerError:
            return .internalServerError
        
        case .unauthorized:
            return .unauthorized
            
        default:
            return .badRequest
        }
    }
    
}

extension ComicInfoError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .requestError:
            return "Request Error"

        case let .itemAlreadyExists(withID: id, itemType: itemType):
            return "\(itemType) already exists with id: \(id)"

        case let .itemNotFound(id, itemType):
            return "We couldn't find \(itemType) with id: \(id)"

        case let .itemsNotFound(ids, itemType):
            let desc = "We couldn't find \(itemType)"
            guard let ids = ids, !ids.isEmpty else {
                return desc
            }
            return "\(desc) with ids: \(ids.sorted())"

        case let .summariesAlreadyExist(IDs):
            return "Summaries already exist withIDs: \(IDs.sorted())"

        case let .invalidFields(fields):
            return "Invalid fields: \(fields.sorted())"
            
        case .requestBodyIsMissing:
            return "Required request body is missing"
            
        case .pathParameterIDIsMissing:
            return "Required path parameter id is missing."
            
        case let .queryParameterIsMissing(type):
            return "Method not allowed: You need to specify query parameter \(String.getType(from: type).lowercased())ID."
        
        case .userIDIsMissing:
            return "Required parameter user ID is missing."
            
        case let .invalidQueryParameterLimit(message):
            return "Invalid query parameter limit: \(message)"
            
        case let .invalidQueryParameterOffset(message):
            return "Invalid query parameter offset: \(message)"
        
        case let .cannotUpdateItemID(type):
            return "Can not update \(String.getType(from: type).lowercased()) identifier"
            
        case .handlerUnknown:
            return "Handler Unknown"
            
        case .unauthorized:
            return "Unauthorized"
            
        case .internalServerError:
            return "Internal Server Error"
        }
    }

}
