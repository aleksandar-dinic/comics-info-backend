//
//  GetQueryParameterAfterID.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/03/2021.
//

import Foundation

protocol GetQueryParameterAfterID {
    
    func getAfterID(from queryParameters: [String: String]?) -> String?
    
}

extension GetQueryParameterAfterID {
    
    func getAfterID(from queryParameters: [String: String]?) -> String? {
        queryParameters?["afterID"]
    }
    
}
