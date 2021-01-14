//
//  UpdateRepositoryAPIService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol UpdateRepositoryAPIService {

    func update(_ items: [DatabaseUpdateItem]) -> EventLoopFuture<Void>

    func getAllSummaries(forID summaryID: String, from table: String) -> EventLoopFuture<[DatabaseGetItem]>
    
}
