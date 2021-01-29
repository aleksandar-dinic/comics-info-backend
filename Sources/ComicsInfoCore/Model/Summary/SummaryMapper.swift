//
//  SummaryMapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 21/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol SummaryMapper: ComicInfoItem {
    
    var popularity: Int { get }
    var name: String { get }
    var thumbnail: String? { get }
    var description: String? { get }

    func shouldUpdateExistingSummaries(_ updatedFields: Set<String>) -> Bool
    
}

extension SummaryMapper {
    
    public func shouldUpdateExistingSummaries(_ updatedFields: Set<String>) -> Bool {
        !Set(arrayLiteral: "popularity", "name", "title", "thumbnail", "description")
            .intersection(updatedFields)
            .isEmpty
    }
    
}
