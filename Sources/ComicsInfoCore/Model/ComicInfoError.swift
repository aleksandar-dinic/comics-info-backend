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
    case pathParameterIDIsMissing
    case queryParameterSeriesIDIsMissing
    case invalidQueryParameterLimit(message: String)
    case invalidQueryParameterOffset(message: String)
    case handlerUnknown
    case internalServerError

}

extension ComicInfoError {
    
    var responseStatus: HTTPResponseStatus {
        switch self {
        case .requestError:
            return .badRequest
            
        case .itemAlreadyExists:
            return .conflict
            
        case .itemNotFound:
            return .noContent
            
        case .itemsNotFound:
            return .noContent
            
        case .summariesAlreadyExist:
            return .conflict
            
        case .invalidFields:
            return .badRequest
            
        case .pathParameterIDIsMissing:
            return .badRequest
            
        case .queryParameterSeriesIDIsMissing:
            return .methodNotAllowed
            
        case .invalidQueryParameterLimit:
            return .badRequest
            
        case .invalidQueryParameterOffset:
            return .badRequest
            
        case .handlerUnknown:
            return .internalServerError
            
        case .internalServerError:
            return .internalServerError
            
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
            
        case .pathParameterIDIsMissing:
            return "Required path parameter id is missing."
            
        case .queryParameterSeriesIDIsMissing:
            return "Method not allowed: You need to specify query parameter seriesID."
            
        case let .invalidQueryParameterLimit(message):
            return "Invalid query parameter limit: \(message)"
            
        case let .invalidQueryParameterOffset(message):
            return "Invalid query parameter offset: \(message)"

        case .handlerUnknown:
            return "Handler Unknown"
            
        case .internalServerError:
            return "Internal Server Error"
        }
    }

}
