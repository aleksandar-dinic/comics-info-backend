//
//  CreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateAPIWrapper: CreateCharactersSummaryAPIWrapper, CreateSeriesSummaryAPIWrapper, CreateComicsSummaryAPIWrapper {

    associatedtype Item

    func create(_ item: Item) -> EventLoopFuture<Void>

}
