//
//  Request.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Request: Codable {

    public let pathParameters: [String: String]?
    public let queryParameters: [String: String]?
    public let headers: [String: String]?
    public let body: String?
    
    init(
        pathParameters: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: String? = nil
    ) {
        self.pathParameters = pathParameters
        self.queryParameters = queryParameters
        self.headers = headers
        self.body = body
    }
    
    enum CodingKeys: String, CodingKey {
        case pathParameters
        case queryParameters = "queryStringParameters"
        case headers
        case body
    }
    
    /// Path Parameters
    
    func getIDFromPathParameters() throws -> String {
        guard let id = pathParameters?["id"] else {
            throw ComicInfoError.pathParameterIDIsMissing
        }
        
        return id
    }
    
    /// Query Parameters
    
    func getAfterIDFromQueryParameters() -> String? {
        queryParameters?["afterID"]
    }
    
    func getLimitFromQueryParameters() throws -> Int {
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
    
    func getCharacterIDFromQueryParameters() throws -> String {
        guard let characterID = queryParameters?["characterID"] else {
            throw ComicInfoError.queryParameterIsMissing(type: Character.self)
        }
        
        return characterID
    }
    
    func getCharacterSummaryIDFromQueryParameters() throws -> String {
        guard let characterSummaryID = queryParameters?["characterID"] else {
            throw ComicInfoError.queryParameterIsMissing(type: Character.self)
        }
        
        return .comicInfoID(for: CharacterSummary.self, ID: characterSummaryID)
    }
    
    func getSeriesIDFromQueryParameters() throws -> String {
        guard let seriesID = queryParameters?["seriesID"] else {
            throw ComicInfoError.queryParameterIsMissing(type: Series.self)
        }
        
        return seriesID
    }
    
    func getSeriesSummaryIDFromQueryParameters() throws -> String {
        guard let seriesSummaryID = queryParameters?["seriesID"] else {
            throw ComicInfoError.queryParameterIsMissing(type: Series.self)
        }
        
        return .comicInfoID(for: SeriesSummary.self, ID: seriesSummaryID)
    }
    
    /// Headers
    
    func getTokenFromHeaders() throws -> String {
        guard let token = headers?["authorization"] else {
            throw ComicInfoError.unauthorized
        }
        
        return token
    }
    
    /// Body
    
    func encodeBody(using encoding: String.Encoding = .utf8) throws -> Data {
        guard let data = body?.data(using: encoding) else {
            throw ComicInfoError.requestBodyIsMissing
        }
        
        return data
    }

}
