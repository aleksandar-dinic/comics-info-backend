//
//  GetCharacterSummaries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol GetCharacterSummaries {
    
    var characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>> { get }
    
    func getSummaries(
        _ item: Character,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<[CharacterSummary]?>
    
}

extension GetCharacterSummaries {
    
    func getSummaries(
        _ item: Character,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<[CharacterSummary]?> {
        var criteria = [GetSummaryCriteria<CharacterSummary>]()
        
        for id in item.seriesID ?? [] {
            criteria.append(GetSummaryCriteria(
                                itemID: .comicInfoID(for: Series.self, ID: id),
                                summaryID: .comicInfoID(for: item),
                                table: table
            ))
        }
        
        for id in item.comicsID ?? [] {
            criteria.append(GetSummaryCriteria(
                                itemID: .comicInfoID(for: Comic.self, ID: id),
                                summaryID: .comicInfoID(for: item),
                                table: table
            ))
        }
        
        guard !criteria.isEmpty else { return eventLoop.submit { nil } }
        
        return characterUseCase.getSummary(on: eventLoop, with: criteria)
    }
    
}
