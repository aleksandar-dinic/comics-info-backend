//
//  GetQueryParameterSeriesID.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/03/2021.
//

import Foundation

protocol GetQueryParameterSeriesID {
    
    func getSeriesID(from queryParameters: [String: String]?) throws -> String
    func getSeriesSummaryID(from queryParameters: [String: String]?) throws -> String
    
}

extension GetQueryParameterSeriesID {
    
    func getSeriesID(from queryParameters: [String: String]?) throws -> String {
        guard let seriesID = queryParameters?["seriesID"] else {
            throw ComicInfoError.queryParameterIsMissing(type: Series.self)
        }
        
        return seriesID
    }
    
    func getSeriesSummaryID(from queryParameters: [String: String]?) throws -> String {
        guard let seriesSummaryID = queryParameters?["seriesID"] else {
            throw ComicInfoError.queryParameterIsMissing(type: Series.self)
        }
        
        return .comicInfoID(for: SeriesSummary.self, ID: seriesSummaryID)
    }
    
}
